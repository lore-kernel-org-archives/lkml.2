Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532Ab2CPMqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:46:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:58308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab2CPMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:46:54 -0400
Message-ID: <4F63362E.1090701@windriver.com>
Date: Fri, 16 Mar 2012 07:46:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 3/4] kgdb: Respect that flush op is optional
References: <cover.1331900215.git.jan.kiszka@siemens.com> <08ddbfb8fbca5fef8adfce3449b5744b0db7b45f.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <08ddbfb8fbca5fef8adfce3449b5744b0db7b45f.1331900215.git.jan.kiszka@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 07:17 AM, Jan Kiszka wrote:
> Not all kgdb I/O drivers implement a flush operation. Adjust
> gdbstub_exit accordingly.

The flush is certainly optional.  The reason we never saw this bug is because it was only used by some code not in the mainline, where it is in fact patched.  The out of tree patch hooked into the reboot notifier.

It makes me wonder if using the reboot notifier is enough vs the call backs you placed in the critical power off points in your patch [4/4].   I'll respond separately to that thread because there are other folks in the CC line.

If we decide to roll with this series, I will definitely merge this patch, else I will remove the code since it is not used except for out of tree patches.

Thanks,
Jason.

