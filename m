Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0DTFek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:34:40 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:45826 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab0DTFej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=aTAuNjymdoJuKWPX21zhWAHLOVqZzN3EwJ80to7pdaMuLX9CIrTgDRKOaOC1K2gU66
         fqit8cKqsQgrIAE1lA/f9t/qA6iaS6xkeb8nXB7U43uV1v0UwZeOBhm7XHVaVUEJ2n3v
         jN5iH+J8IbRpf5ed7k/872BZZpUavR2zIp9p0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100419170059.GB29819@opensource.wolfsonmicro.com>
References: <h2t427d64721004181858s4c01a195ma70d3ce96ee2d343@mail.gmail.com> 
	<20100419170059.GB29819@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 20 Apr 2010 13:34:18 +0800
Message-ID: <s2y427d64721004192234x96d286e4teab6f32323d2b291@mail.gmail.com>
Subject: Re: [PATCH] mc13783-regulator: fix a memory leak in 
	mc13783_regulator_remove
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,

2010/4/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Apr 19, 2010 at 09:58:02AM +0800, Axel Lin wrote:
>> This patch fixes a memory leak by freeing priv in mc13783_regulator_remove
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> but note that...
>
>> +       platform_set_drvdata(pdev, NULL);
>> +
>
> This is completely unrelated to what your description says (and is not
> needed).
>

In the probe function , the driver uses platform_set_drvdata(pdev,
priv) to store a pointer to the priv data structure.
To avoid leaving a dangling pointer behind, the driver should clear
the pointer to priv before freeing priv.

Regards,
Axel
