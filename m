Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0FCFDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:03:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58856 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0FCFDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GvP6wkNTH1U5U0z12Zy2S9CqvQ+I2nWfbJ5usY6Zb6DQWdw5Tf/fMQFHs8OO1I85JN
         7akUW3xVtRPqobQ9Ni2eAY7Fldir4HCIWx3Ds0kxzkf2S9aSlSMQNYWcztxGDAkz6+G5
         PAo5KVw1B0LLKpPwASMdmjRUCYxytSLVWl39w=
MIME-Version: 1.0
In-Reply-To: <op.vdojfktu7p4s8u@pikus>
References: <cover.1275481997.git.mina86@mina86.com>
	<5e151207bced1e418bcfed136a871d2da47e417e.1275481997.git.mina86@mina86.com>
	<e4cb4e647e0ebc51956d6581cd930e3d32f29b99.1275481997.git.mina86@mina86.com>
	<785f09f63fe30ba52ce15fd7cb3f5750aa279ab9.1275481997.git.mina86@mina86.com>
	<5492eaf531c8a59c7c188b9e341572c9cdaed5f2.1275481997.git.mina86@mina86.com>
	<17b54e2cc00a7f730483401f06c79c781491dc62.1275481997.git.mina86@mina86.com>
	<381c3f8318e39caaffa1ecfdf5e3cf13ed59cd27.1275481997.git.mina86@mina86.com>
	<c8725442e3c5b8c7be2cc381ed69a3dc0283ebe1.1275481997.git.mina86@mina86.com>
	<AANLkTikAhJXiKGzyK7j3V7ev_6f2mn8f-A9tDmgdHy9I@mail.gmail.com>
	<op.vdojfktu7p4s8u@pikus>
Date: Thu, 3 Jun 2010 13:03:19 +0800
Message-ID: <AANLkTinwDV9Egrfy_ml998vWIKWs5AasrJMrgxIWOrCo@mail.gmail.com>
Subject: Re: [PATCHv3 07/11] USB: gadget: g_multi: added documentation and INF 
	files
From: Xiaofan Chen <xiaofanc@gmail.com>
To: =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org, "mina86@mina86.com" <mina86@mina86.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/2 Michał Nazarewicz <m.nazarewicz@samsung.com>:
> On Wed, 02 Jun 2010 15:02:54 +0200, Xiaofan Chen <xiaofanc@gmail.com> wrote:
>>
>> [Version]
>> Signature="$Windows NT$"
>> Class=Ports
>> ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
>> Provider=%MFGNAME%
>> LayoutFile=layout.inf
>> CatalogFile=%MFGFILENAME%.cat
>
> So, what is this cat file for?  I changed the IDs and the INF file started
> working even though I expected that this file will be required.  I'm
> wondering is it because I have something installed on my Windows
> box that others may miss?

You do not need the cat file in this case. Microchip's Driver Package is
WHQLed, in that case, the cat file will have the necessary
digital certificate (Verisign Class 3 code signing certificate for WHQL).
You can also sign your driver package with other valid certificates
(GlobalSign) for KMCS requirement. In this case, the kernel driver
is already signed by Microsoft, you do not need the signed driver
package (cat file) to load the driver in 64bit Vista/Win7. But there
will be a warning (for 32bit/64bit XP/Vista/Win7). Once you pay
money and go through WHQL process, the warning will not be there.

In a word, that line can be deleted.

> And what's with the layout.inf.
Ah, I think that should not be there now. Only system provided
INF file should have that line (eg: mdmcpq.inf which is included
in the Microchip INF file). You can remove that line.

More information:
http://support.microsoft.com/kb/837637



-- 
Xiaofan http://mcuee.blogspot.com
