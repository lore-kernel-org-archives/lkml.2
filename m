Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1HKTus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:50:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1HKTur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:50:47 -0400
Date: Thu, 11 Aug 2011 23:50:34 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Hutchings <ben@decadent.org.uk>,
        Christian Ohm <chr.ohm@gmx.net>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: re: perf tools: Check $HOME/.perfconfig ownership
Message-ID: <20110811195033.GA17313@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 069e3725dd9be3b759a98e8c80ac5fc38b392b23 introduced a check
whether $HOME/.perfconfig file is owned by the user.  Three comments here:

1) How other user may create a file in other user's home directory?  If
we assume he may do it, the situation is bad without any perf :(

2) If we assume (1) is somehow possible (e.g. other user may manipulate
this file only), there is a race against file creation/deletion and stat.

3) .perfconfig can be a symlink, so stat(2) should be changed to
lstat(2).


Thanks,

-- 
Vasiliy
