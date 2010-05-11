Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0EKRyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:54:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42409 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0EKRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ovAtIeLHW6L1uD45wYopfIgfXwLQ7uSjeK87bLBjpuRVN75AMQomWAm10zX4gmueQB
         NEUfra0KkL2LK/Hfg3NrLNTT8OjBcGM/X+Ee4zieEsEnIgO4t+pKepB+cWchWiswyJ8g
         r4UvSzENrU6bkCAcOH5dEnM6qCO7q00lBjUsM=
MIME-Version: 1.0
In-Reply-To: <1273553765.21352.1.camel@pasglop>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-14-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-15-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-16-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-17-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-18-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-19-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
	 <AANLkTinOVSpCXdkkcCHMdN-HWsImE7_Gcbgg5plnNMss@mail.gmail.com>
	 <1273553765.21352.1.camel@pasglop>
Date: Tue, 11 May 2010 10:54:11 -0700
X-Google-Sender-Auth: GRXt1ojejd3Gubwpkvt1lNtbbUw
Message-ID: <AANLkTilUCwtBfi2xHIN1bQAcY1irmpOb6Hn0tyJeYOuV@mail.gmail.com>
Subject: Re: [PATCH 19/25] lmb: Add array resizing support
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 9:56 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2010-05-10 at 16:59 -0700, Yinghai Lu wrote:
>> you need to pass base, base+size with lmb_double_array()
>>
>> otherwise when you are using lmb_reserve(base, size), double_array()
>> array could have chance to get
>> new buffer that is overlapped with [base, base + size).
>>
>> to keep it simple, should check_double_array() after lmb_reserve,
>> lmb_add, lmb_free (yes, that need it too).
>> that was suggested by Michael Ellerman.
>>
>
> No. You may notice that I addressed this problem by moving the
> call to lmb_double_array() to -after- we record the entry in
> the array, so it shouldn't be able to pickup the same one.

oh, you are right.
