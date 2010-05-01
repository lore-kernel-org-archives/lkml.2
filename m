Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0EAP3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 11:29:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:56984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753351Ab0EAP3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 11:29:45 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+WhB9n5xOWqPqjWd415vCUkK8ijJN/yi5o0VrdWu
	6KyKPg/fcGEOOe
Message-ID: <4BDC48E4.8000202@gmx.de>
Date: Sat, 01 May 2010 17:29:40 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 12/30] viafb: Move core stuff into via-core.c
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>	<1272493051-25380-13-git-send-email-corbet@lwn.net>	<4BDC4286.4070703@gmx.de> <20100501090827.72e9da71@bike.lwn.net>
In-Reply-To: <20100501090827.72e9da71@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> On Sat, 01 May 2010 17:02:30 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>>>  struct fb_info *viafbinfo;
>>> +EXPORT_SYMBOL_GPL(viafbinfo);
>>>  struct fb_info *viafbinfo1;
>>>  struct viafb_par *viaparinfo;
>>> +EXPORT_SYMBOL_GPL(viaparinfo);
>>>  struct viafb_par *viaparinfo1;  
>> Ugh, I really hope you introduce those only as temporary exports until 
>> the split is finished. It's ugly enough that viafb uses these internally 
>> as global variables which will vanish in some time but for a 
>> multifunction driver having those sounds even more ridiculous. If we 
>> agree that it's only a temporary solution I'll take this bitter pill.
> 
> No we don't agree...  what we're seeing here is some history that I did
> not succeed in getting rid of entirely.  Those exports have no reason
> to exist anymore and shouldn't have slipped through into that patch.  I
> will most certainly make them go away.

That's even better.

>>> @@ -1764,6 +1765,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>>>  		&viaparinfo->shared->lvds_setting_info2;
>>>  	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
>>>  	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
>>> +	spin_lock_init(&viaparinfo->reg_lock);  
>> I think the initialization of the lock that is made for synchronization 
>> of hardware access should be in the via-core.c you just introduce. (and 
>>   the lock itself in a structure or something outside the framebuffer 
>> flow). Just saw that you did so in your next patch, so there is no 
>> reason to needlessly introduce the spinlock now.
> 
> As you note, it's only there for one step in the series, and no
> electrons are harmed in the process.  Is this really worth the trouble
> of changing?

Well I only noticed it just before sending. Not needlessly changing code 
would make the patches simpler but as I know now what is going on I 
don't insist on changing it.


Thanks,

Florian Tobias Schandinat
