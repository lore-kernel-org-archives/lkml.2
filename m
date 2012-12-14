Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006Ab2LNXKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:10:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41086 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945905Ab2LNXKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:10:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
	<1355519048-28473-1-git-send-email-nhorman@tuxdriver.com>
Date: Fri, 14 Dec 2012 15:10:30 -0800
In-Reply-To: <1355519048-28473-1-git-send-email-nhorman@tuxdriver.com> (Neil
	Horman's message of "Fri, 14 Dec 2012 16:04:08 -0500")
Message-ID: <87d2ycut5l.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/wJWvniJiomJnE04MZkWwftp3FjBNVdbc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0375]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Horman <nhorman@tuxdriver.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] core_pattern: set core helpers root and namespace to crashing process
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> As its currently implemented, redirection of core dumps to a pipe reader should
> be executed such that the reader runs in the namespace of the crashing process,
> and it currently does not. This is the only sane way to deal with namespaces
> properly it seems to me, and this patch implements that functionality.

I actually rather strongly disagree.

While we have a global core dump pattern core dumps to a a pipe reader
should be executed such that the reader runs in the namespace of the
process that set the pattern.  We can easily restrict that to the
initial namespaces to make the implementation simpler.

If you want to play namespace games you can implement all of those in
user space once my tree merges for v3.8.

I am really not a fan of the trigger process being able to control the
environment of a privileged process.  It makes writing the privileged
process much trickier.

Eric
