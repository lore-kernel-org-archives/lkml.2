Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0LLTcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:32:42 -0500
Received: from capside.net ([81.19.98.74]:35164 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0LLTcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:32:41 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 14:32:40 EST
Date: Sun, 12 Dec 2010 20:25:54 +0100
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
Message-ID: <20101212192554.GA32583@bart.evergreen.loc>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292180668.18202.43.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292180668.18202.43.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:04:28AM -0800, Joe Perches wrote:
> On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> > Fix checkpatch complains
> > diff --git a/drivers/staging/rt2860/common/ee_efuse.c b/drivers/staging/rt2860/common/ee_efuse.c
> []
> > @@ -281,8 +281,8 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg)
> >  
> >  		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
> >  		if (i % 4 == 0)
> > -			printk("\nBlock %x:", i / 8);
> > -		printk("%04x ", InBuf[2]);
> > +			printk(KERN_DEBUG "\nBlock %x:", i / 8);
> > +		printk(KERN_DEBUG "%04x ", InBuf[2]);
> >  	}
> >  	return TRUE;
> >  }
> 
> Not quite.  Use:
> [...]

Ok.

> > diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
> >[...]
> > -#ifdef DEBUG
> > -		printk("RTMPAllocateNdisPacket Fail\n");
> > -#endif
> > +		printk(KERN_DEBUG "RTMPAllocateNdisPacket Fail\n");
> 
> Behavior change.
> Using pr_devel would be exactly the same.
> Using pr_debug would enable dynamic debug.

You are completely right. I guessed that DEBUG would be a developer-defined
definition. Will fix with pr_devel, makes more sense to me.

> 
> > @@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
> >[...]
> This should use print_hex_dump

Ok, but I'll have to figure out how to translate the arguments without losing
the original developers intended format.

> 
> > diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
> []
> >  #define DBGPRINT_ERR(Fmt)           \
> >  {                                   \
> > -    printk("ERROR! ");          \
> > +    printk(KERN_ERR "ERROR! ");          \
> >      printk Fmt;                  \
> >  }
> 
> Better ways to do this:
> 
> #define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
> or
> #define DBGPRINT_ERR(fmt, ...) printk(KERN_ERR fmt, ##__VA_ARGS__)

Thanks for your review. Will resend.


Regards,

-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
