Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0I0NDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:03:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36390 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0I0NC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cQKtOVd6yzOLi6zaP5hDJ3FgMaA0APUqB9+cKGo31ycmko/urNYt4/0L0DEBX+Jz2m
         T6tmcC7EnoMBmusH+hkZLTLhPd5htURuIsibBNW4Ee9siWHV9p/rtR8rNcOzRbaseVwG
         SXLUOh/OLl3eHk5H2dwFDevP8fpzkP9NDqdJM=
MIME-Version: 1.0
In-Reply-To: <20100927125946.GB2862@elte.hu>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
	<20100927125946.GB2862@elte.hu>
Date: Mon, 27 Sep 2010 16:02:57 +0300
X-Google-Sender-Auth: DAOpM42LKBaykZ2cH7Qfy_9furM
Message-ID: <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is undefined
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, torvalds@linux-foundation.org,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 3:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
>
>> +#ifdef CONFIG_SMP
>> +#endif
>> +#ifdef CONFIG_SMP
>> +#endif
>
> Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one
> that doesnt involve preprocessor directives?

Implement cpu_sibling_mask() on UP so that the loop goes away?
