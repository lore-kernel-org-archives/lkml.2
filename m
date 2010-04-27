Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0D0RuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:50:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47654 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0D0RuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:50:23 -0400
From: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Organization: Nokia-D/Helsinki
To: oprofile-list@lists.sourceforge.net
Subject: Re: [GIT PULL] updates for oprofile
Date: Tue, 27 Apr 2010 20:47:51 +0300
User-Agent: KMail/1.9.9
Cc: ext Robert Richter <robert.richter@amd.com>,
       "Carmody Phil.2 (EXT-Ixonos/Helsinki)" <ext-phil.2.carmody@nokia.com>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100427152544.GA9063@pcarmody-desktop> <20100427174026.GR6450@erda.amd.com>
In-Reply-To: <20100427174026.GR6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004272047.52056.siarhei.siamashka@nokia.com>
X-OriginalArrivalTime: 27 Apr 2010 17:50:05.0826 (UTC) FILETIME=[12008E20:01CAE632]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010 20:40:26 ext Robert Richter wrote:
> On 27.04.10 18:25:44, Phil Carmody wrote:
> > Now oprofile_add_sample() is called from this context:
> > """
> > static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer
> > *hrtimer) {
> >          oprofile_add_sample(get_irq_regs(), 0);
> > """
> >
> > And get_irq_regs() is NULL when not in an IRQ context.
>
> Perf is simply dropping the sample in such cases, see:
>
>  kernel/perf_event.c:perf_swevent_hrtimer()
>
> So at quick fix would be to check for a null pointer also. But,
> according to this:
>
>  http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14074.html
>
> samples will be incorrect then since only interrupt context is
> profiled. It seems there is no solution available right now.

Isn't hrtimer callback function supposed to be only called from IRQ context
after this cleanup: http://lwn.net/Articles/308545/ ?

-- 
Best regards,
Siarhei Siamashka
