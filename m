Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab1EAQYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:24:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57875 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab1EAQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=KH2CbmHQI2V8Mgs0exxuHKALcfhig5vyHfvXuiKuyN+AFciNi55hOzUlYp2zk+Orcg
         ogX2X+uq8jyGmnK1dsflSLuvl3B5G9rxuWp2qCh8oaulsMdwWaKlCWYFOXZyaU8f7bhx
         VIe8ifZ2QEyKd+DHcKbKmBCjQtNkAD0JDYSSo=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110428162620.GA9529@core.coreip.homeip.net>
References: <1302698231.3002.4.camel@phoenix> <20110428162620.GA9529@core.coreip.homeip.net>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 2 May 2011 00:23:43 +0800
Message-ID: <BANLkTi=BpdfE+VmBZuzaodNiE9JUhARbfg@mail.gmail.com>
Subject: Re: [PATCH] Input: h3600_ts_input - bugfix for request_irq()/free_irq()
 parameters
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

2011/4/29 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Wed, Apr 13, 2011 at 08:37:11PM +0800, Axel Lin wrote:
>> The dev field of h3600_dev is a pointer, thus use ts->dev instead of &ts->dev
>> as the dev_id argument while calling request_irq()/free_irq().
>
> dev_id does not need to have specific type, it is just a cookie so as
> long as it's value is unique we are OK. &ts->dev works as well as
> ts->dev.

Then you might want to apply below patch:
http://www.spinics.net/lists/linux-input/msg15042.html

My original intension was to fix the irq driver data mismatch.

Regards,
Axel
