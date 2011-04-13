Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab1DMPm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:42:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56877 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab1DMPm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:42:57 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Date: Wed, 13 Apr 2011 21:12:05 +0530
Subject: RE: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
Thread-Topic: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
Thread-Index: Acv57ocVjxZFb/CjT7eQXvFp4j3JAwAAgaMg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C8B3CBD@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
	<f1ff3f2888725a1e03541e0be5c0880f0591aea2.1302031487.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB593024C8B3C9F@dbde02.ent.ti.com>
 <BANLkTi=j=Dp015ZsU44DH3p1s_XdxvAX8Q@mail.gmail.com>
In-Reply-To: <BANLkTi=j=Dp015ZsU44DH3p1s_XdxvAX8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 20:52:05, Ben Gardiner wrote:

> >> --- a/arch/arm/mach-davinci/devices-da8xx.c
> >> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> >> @@ -324,6 +324,12 @@ int __init da8xx_register_i2c(int instance,
> >>       else
> >>               return -EINVAL;
> >>
> >> +     /*
> >> +      * Both the DA850 and DA830 have an I2C controller which has the
> >> +      * ICPFUNC et. al. registers
> >> +      */
> >> +     pdata->has_pfunc = 1;
> >
> > The I2C driver implements a default platform data
> > so it should actually be legal for a DA8x board to
> > pass NULL platform data. In that case this line
> > will crash.
> 
> Good catch, thanks.
> 
> > [...] You should either check for pdata to
> > be NULL or just let each board choose whether it
> > needs recovery (I think the better option).
> 
> I understand "check for pdata to be NULL."  If you think it is the
> better option I'd be happy to implement it but I don't understand how
> to implement "let each board choose whether it needs recovery."

This is done by just setting has_pfunc = 1 in the
davinci_i2c_platform_data defined in the board file.

Thanks,
Sekhar

