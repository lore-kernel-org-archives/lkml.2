Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1BHQgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:36:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1BHQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=JrMTs+uldYRa8PJPQbZslsGMSJJQ9mcR4vDRFhrcaX+VM213YwaNz5FYEqQ8/p8DjR
         ul9yGql1vsc/eLcEvxqwPSnx9HrdEN9t45yQ8rFPOmECcwkCV90M6dNzSN/8mZRKrbaY
         9u/EtubWVRHJ3UZftxnQqxA2vIaLcjes7os1U=
Date: Tue, 8 Feb 2011 19:35:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in
 write_blk_fifo() function.
Message-ID: <20110208163531.GO4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Belisko Marek <marek.belisko@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
 <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
 <20110126130718.GN2721@bicker>
 <20110126143045.GP2721@bicker>
 <AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 02:40:49PM +0100, Belisko Marek wrote:
> On Wed, Jan 26, 2011 at 3:30 PM, Dan Carpenter <error27@gmail.com> wrote:
> > Also when it does:
> >        memcpy(ft1000dev->tx_buf, *pUcFile, byte_length);
> >
> > That should probably be:
> >        memcpy(ft1000dev->tx_buf, *pUcFile, word_length * 4);
> No this shouldn't because before you have additional check:
> if (byte_length && ((byte_length % 64) == 0))
>         byte_length += 4;
> 
> if (byte_length < 64)
>         byte_length = 68;
> So in my opinion byte_length should stay.

Yes.  We make byte_length longer than the caller intended.  The caller
knows the size of the source buffer.  We have to pad the length of the
other buffer, but we should fill up the last part with zeroes instead
of reading past the end of the source buffer.

(I am not very familiar with the code and I haven't looked outside this
function, so I may be wrong).

Also I really bet that the thing where byte_length can't be a multiple
of 64 is bogus.  I've never heard of anything with a requirement like
that.

regards,
dan carpenter


