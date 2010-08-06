Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403Ab0HFOAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:00:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:54558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0HFOAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:00:30 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Boot-time dynamic debugging?
Date: Fri, 6 Aug 2010 16:03:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, bjorn.helgaas@hp.com
References: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com> <AANLkTi=k5nkUk9LOS=EGHGSq=5Qe8_L-1d3_t9byxMrt@mail.gmail.com> <201008021614.00038.trenn@suse.de>
In-Reply-To: <201008021614.00038.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008061603.54058.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 16:13:59 Thomas Renninger wrote:
> On Monday 02 August 2010 15:53:24 Pekka Enberg wrote:
...
> > Btw, can you easily enable all dev_dbg() calls with the boot parameter?
> I expect yes, but never explicitly tried it, dev_dbg should result in
> printk(KERN_DEBUG ...) after some macro/inline func processing.
My statement was wrong, from what I can see having a closer look:
printk(KERN_DEBUG...) messages will not show up, but dev_dbg will:
----------
asmlinkage int printk(const char * fmt, ...)
        __attribute__ ((format (printf, 1, 2))) __cold;
static inline int printk(const char *s, ...)
        __attribute__ ((format (printf, 1, 2)));
----------
I wonder whether the KERN_DEBUG can be differed at compile time
and could also result in a dynamic_pr_debug...

----------
#elif defined(CONFIG_DYNAMIC_DEBUG)
/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
#define pr_debug(fmt, ...) \
        dynamic_pr_debug(fmt, ##__VA_ARGS__)

#elif defined(CONFIG_DYNAMIC_DEBUG)
#define dev_dbg(dev, format, ...)                    \
do {                                                 \
        dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
}
----------

      Thomas
