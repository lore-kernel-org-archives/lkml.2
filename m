Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2FKNwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:52:14 -0400
Received: from ngcobalt02.manitu.net ([217.11.48.102]:39020 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2FKNwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:52:12 -0400
X-manitu-Original-Sender-IP: 79.214.40.70
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <4FD5F7F1.3010602@grandegger.com>
Date: Mon, 11 Jun 2012 15:51:45 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: alan@lxorguk.ukuu.org.uk, federico.vaga@gmail.com, mkl@pengutronix.de,
        giancarlo.asnaghi@st.com, alan@linux.intel.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
References: <20120604165619.15ba43bf@pyramind.ukuu.org.uk>  <4FC135C6.5030206@grandegger.com>  <1338816766-7089-1-git-send-email-federico.vaga@gmail.com>  <1338816766-7089-2-git-send-email-federico.vaga@gmail.com> <20120604164531.GA22000@mail.gnudd.com>
In-Reply-To: <20120604164531.GA22000@mail.gnudd.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:45 PM, Alessandro Rubini wrote:
>> Anythign wrong with 
>>
>> bool aligned32;
> 
> I personally think booleans are evil.  But both this and the other
> thing:
> 
>>> +static u16 c_can_pci_read_reg_aligned_to_16bit(struct c_can_priv *priv,
>>> +						void *reg)
>>
>> I'm a bit worried this function name might be too short ;)
> 
> come from the platform driver this is based on (I already blamed
> federico offlist for not preserving authorship of the original file).
> 
> So, this file is mostly copied from the platform driver, which is a
> duplication of code.  A mandated duplication, given how the thing
> is currently laid out: the c_can core driver exports functions that
> the other two files are using (the platform and the new pci driver).
> 
> In my opinion, it would be much better to have one less layer and no
> exports at all. The core driver should be a platform driver, and the
> pci driver would just build platform data and register the platform
> device.

Do you have examples for that approach? Not sure yet if it really saves
code and makes it more readable.

> Sure this isn't up to federico, who has the pci device but cannot
> access any boards where the previous driver is used.  What do the
> maintainers think? I (or federico :) may propose a reshaping, if
> the idea makes sense.

I would suggest to provide the c_can_pci driver using the *current* API,
even if it's not optimal. Federicos patch then already looks quite good.
It should use the new register access methods introduced by the D_CAN
support patch, though.

Any further improvements to the device abstraction and a more consistent
handling of the platform data are welcome.

Wolfgang.



