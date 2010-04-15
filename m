Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0DOAal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:30:41 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50214 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0DOAaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Yh90KEm6pOJ2nrWfqE/OcJP1aL/X/JGRge4ej51NaYpdV7uKXP4U6JeNpJ1Wtlrogw
         4WFxE3QhtR0wEmGXDpzFM3OcxKrhky9KpCj0G1MhtecsSsvqrmgNwuhp/KeR0tPVKutw
         vuyiAwiqYSvwK3VQXXrdvgjEP5t2hxl5U19eE=
MIME-Version: 1.0
In-Reply-To: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
References: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
Date: Wed, 14 Apr 2010 17:30:39 -0700
X-Google-Sender-Auth: fc17e0b2fcbfda23
Message-ID: <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
Subject: Re: Dmaengine query
From: Dan Williams <dan.j.williams@intel.com>
To: rd bairva <rbairva@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:26 PM, rd bairva <rbairva@gmail.com> wrote:
> Hi Dan,
>
>        I am currently writing dmaengine compatible DMA driver for our ARM
> based architecture, But I am facing some performance issues doing
> that.
>
> 1. dmaengine says callback should run in tasklet, and next transfer
> cannot be scheduled from the callback.
>
> Due to these restrictions I am getting some performance issue while
> playing sound in our architecture.
>
>
> Can callback call in DMA driver be placed out of spin_lock to submit
> new operations from callback? (only in asynchronous case)
>
> is this Ok? please comment.

Other dma driver authors are dropping the lock across the call to the
callback in the mem-to-io case.  The compliance points in the
documentation are primarily targeted at the expectations of the
async_tx api.  In the mem-to-io (slave dma) model you are not using
the async_tx api.

--
Dan
