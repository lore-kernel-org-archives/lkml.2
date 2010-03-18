Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0CRJbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:31:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53672 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0CRJbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UF6lUfJOK/AwSFvij6zIRQH6SnLj10PaSym6vgDeQiJAI7bQlCueeebjfH+dz+gxwJ
         VLj44xxoafiVSXTff+VS9nMvovbD3rnaGIvcYe183f56OZnsGD1YKDChyE48H4vXtxha
         0dUm8pOGDlGiAx7ujwl/aihI8EwWin2zT+GxY=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.1003181015060.9334@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003181015060.9334@obet.zrqbmnf.qr>
Date: Thu, 18 Mar 2010 17:31:33 +0800
Message-ID: <2375c9f91003180231n85501e2u951e6d8bbffce5d3@mail.gmail.com>
Subject: Re: kconfig: report select on a depending option
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Michal Marek <mmarek@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 5:21 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Hi,
>
>
> With the following combination of Kconfig config options, I can select
> TEST_Z, which will select TEST_X, even if TEST_Y=n. It also allows for
> awkward situations like TEST_Y=M, TEST_X=y, TEST_Z=y, which would yield
> a link time error when X uses Y's symbols.
> Is there a way to have such potential errors reported with kconfig?
>
> config TEST_Y
>        tristate "Y"
>
> config TEST_X
>        depends on Y
>        tristate "X"
>
> config TEST_Z
>        select TEST_Y

You mean "select TEST_X" here, right?

>        tristate "Z"
>

I think you should use "depends on X" instead of "select X".
