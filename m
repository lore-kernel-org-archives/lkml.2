Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab1FQIhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:37:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab1FQIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GNjeCGWLqJWa70Kzzy9T+V8HCHItQ2QUQ1iSkk8FVAZB6Gihnp8vYjpCCPoSh5+4l4
         8NKyMQmIX8OJpmCTGFsWciCTnC9UvtH6WJnHCSlaC+Yf1jTHYsdWqUEHZy1bOPHIiMfS
         nqH3xSBjqQHheif/ZVhgl1h96Gjwng8z8ugEc=
Date: Fri, 17 Jun 2011 12:36:51 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        kernel-hardening@lists.openwall.com
Subject: How to temporary change 'current' (task)
Message-ID: <20110617083651.GA5625@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder whether there is a simple way to temporary switch 'current' to
another task and then switch it back with minimum side effects?  I need
it to call "reversed" ptrace_may_access() with swapped current and
target task.  Introducing ptrace_task_may_access_me() would produce too
much noise in LSM (it also needs reversed security_ptrace_access_check()),
which is too loud for my needs.

Specifically, I need it to filter taskstats and proc connector requests
for a restriction of getting other processes' information:

http://permalink.gmane.org/gmane.linux.kernel/1155354

As the check is handled in the context of the ptrace target process,
ptrace_may_access() doesn't fit my needs.

Thanks,

-- 
Vasiliy
