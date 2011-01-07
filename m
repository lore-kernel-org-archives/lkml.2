Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1AGGHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:07:31 -0500
Received: from nm9-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.197]:22062 "HELO
	nm9-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752657Ab1AGGHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:07:30 -0500
X-Yahoo-Newman-Id: 412217.59504.bm@omp1007.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.ca;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=UqSyPv7b3FW8Yr6kYJMTZSQ+PJ+22fECikAyTZZNStRX4Q73AmTR/phrC3uxmuQCdpROIHq0YF6BelvcFlQ2fzwYOsBBkSSZnBRxKImy3ujB23SmeJA5K6mAT/k8Oo+i0tY2US1drPBOF8mo/kdq5nc17HyJxD8/LWcpTy3MGqw=  ;
X-Yahoo-SMTP: ZZonA2.swBDTImn33taRY.l9Gg--
X-YMail-OSG: zvzXr4AVM1mB4rThJkNPHBpvRec.7W5o_M.ob0hTeAAYEFa
 iDTxS6g2ezgHVincSCRI7wGYXat_Ur842OvUV3vpNT_jxXFcjZATzmZy0BNN
 hPWSWddyxhsnbGyVhECz_9LCKKzCV67sDj3m.1h2oGFJX9b6cL553syPrhiz
 8_bchRTIFmihNMuE4ewpp_m7HgZoCAP7xjUGpzxzM5e6hP77MY8kFUc3pwtZ
 2BqSH.rWjvWs6sjkj1J68JAhnik8qF.F9dqD6W0ZrNZMNSO.v5lThmZzcnr2
 bMkSjLRPbV8MfKtTgDJc5FOZRW_pxK1gzW4WIpv8Mbx06zQCm
X-Yahoo-Newman-Property: ymail-5
Subject: Re: [patch] vga_switcheroo: comparing too few characters in
 strncmp()
From: Mailing Lists <listsm@yahoo.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110107053054.GA9057@p183.telecom.by>
References: <20110107051227.GD1717@bicker>
	 <20110107053054.GA9057@p183.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 23:07:22 -0700
Message-ID: <1294380442.10605.25.camel@Tachyon>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 07:30 +0200, Alexey Dobriyan wrote:
> On Fri, Jan 07, 2011 at 08:12:27AM +0300, Dan Carpenter wrote:
> > This is a copy-and-paste bug.  We should be comparing 4 characters here
> > instead of 3.
> 
> > --- a/drivers/gpu/vga/vga_switcheroo.c
> > +++ b/drivers/gpu/vga/vga_switcheroo.c
> > @@ -346,11 +346,11 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
> >  	if (strncmp(usercmd, "DIS", 3) == 0)
> >  		client_id = VGA_SWITCHEROO_DIS;
> >  
> > -	if (strncmp(usercmd, "MIGD", 3) == 0) {
> > +	if (strncmp(usercmd, "MIGD", 4) == 0) {
> >  		just_mux = true;
> >  		client_id = VGA_SWITCHEROO_IGD;
> >  	}
> > -	if (strncmp(usercmd, "MDIS", 3) == 0) {
> > +	if (strncmp(usercmd, "MDIS", 4) == 0) {
> 
> How about you NUL-terminate, and use strcmp().

Userspace data? How to guarantee NULL terminated string at runtime? 

Still, the string constants being compared against are already NULL
terminated, so he could use strcmp as is.

Also, strcmp() would discard user strings that start with a matching
substring ("DIS", "DISK", "DISH", "DISINTERESTED" would all set
client_id to VGA_SWITCHEROO_DIS, using strncmp(), but strcmp() would
only match "DIS").

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


