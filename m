Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1C2NJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:09:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46825 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1C2NJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Z7DceVgYVvF4YbhuLp3AwAC9VpizYS/Pw9lqDw/EN2hmVMhdHlrbE3JanF9w2K6FsP
         KwlrFVXIVZdQ9yGUzCRqcFs9OlIa6PEIqZc5fLgXbYcxJxekoVVudYbx8AkzSgQzoUXG
         meqo1ahujE+NgKLeUj3Kz9PFA/DHeX3+nY9kM=
Date: Tue, 29 Mar 2011 15:08:55 +0200
From: Tejun Heo <tj@kernel.org>
To: trenn@novell.com, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: stop_con_cpu_nowait() usage in set_mtrr()
Message-ID: <20110329130855.GA16492@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Suresh, Thomas.

This is about the openSUSE complete system freeze at start bug Thomas
just pinged about - https://bugzilla.novell.com/show_bug.cgi?id=672008

I looked through the set_mtrr() code and it's implementing its own
stop_machine() using stop_one_cpu_nowait().  This isn't safe.  There
is only one stop cpu execution context per cpu and the custom
implementation can race against the standard stop_machine() - it can
deadlock with each holding some of the execution contexts and neither
stepping away.

Suresh, is there any reason why set_mtrr() is using its own
synchronization instead of stop_machine()?

Thanks.

-- 
tejun
