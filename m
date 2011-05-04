Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1EDEdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:33:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51795 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1EDEdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=lQqckz1HTLdB0wRRnwAkjpNOE1EojWCh0qCfpLteAplTACDHsKN8VClIoV+YvJR8P5
         rEQh7iogu43m0aSHtzm6SfFh8ClkjpdybTuqTJ8kj6Mtob+EW4nCuLoMrSLpX/kOrKqz
         KlCEyuQcKPqPsf0yr1V/hNtngmeJJvukK9DEE=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110503174710.GH1762@opensource.wolfsonmicro.com>
References: <1304440830.16287.10.camel@phoenix> <20110503174710.GH1762@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 4 May 2011 12:33:33 +0800
Message-ID: <BANLkTimMifZiN-3Gcg2ry_ry-OL0vT8NqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: Put mutex lock down to mc13783_powermisc_rmw
 function
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
2011/5/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, May 04, 2011 at 12:40:30AM +0800, Axel Lin wrote:
>> mc13783_powermisc_rmw function is doing read/modify/write bitmask operations,
>> thus add the lock to protect it.
>> Then we can remove the lock/unlock from the caller.
>
> This should be squashed in with the MFD patch I think otherwise we'll
> get bisection points with either no lock or double locking (which upsets
> lockdep IIRC).  The change itself looks good, though, and similarly for
> patch 2
>

I think these 2 patches are independent from the MFD patch.

The MFD patch modified the mc13xxx_reg_rmw which is not called by
mc13783_powermisc_rmw and mc13783_powermisc_rmw functions.
I double checked the usage of mc13783_powermisc_rmw and mc13783_powermisc_rmw,
I think these 2 patches can be applied either with or without the MFD patch.

Regards,
Axel
