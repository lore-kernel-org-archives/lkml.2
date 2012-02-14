Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2BNVJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:09:23 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37800 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932294Ab2BNVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:09:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sjpeL0QVM1n0ffTFM9RzI8uQJWNT0Vkj9kOya8ViOvkz6I1
 A8wwducoEn8GBSQKj0WAvhAmdl6u31kboGMAt91ZrTSlcI_WXuDL_CIDFila
 9fhQ4SBDXxP68oamR1bj_6vhelj.foqOIDkLaP6WxmRoQw2VQ9uDMEHP4rtE
 3TLOzWAKgn9zclCTCp7eZK3txkWAYUEkd9eQPJvlXPsbfo8xJdi8NuGLyrMN
 qHAn.K6RUEe4n3q0WiEIirpzpVM1.U9u5XAyVSwT5afA2iIcy6VLtsklV65J
 CqF9nk3Agohf3ElJ4p_Gji78EdVitLEgsN9_kzxHRLqnkNPwfnuyHBoaD5Wc
 KIoOQwwQSWP1g4OKbTZteOhrv7uksklbNcaisIQ0C9E5yP14rujYXsrsG1JB
 c
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 15:09:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202141503470.29019@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda>
 <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home>
 <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Pekka Enberg wrote:

> Me neither. I don't think Christoph's SAFE_ARRAY_SIZE() suggestion
> makes much sense, really. It's more verbose, less obvious API, and
> doesn't really deal with the overflow case cleanly.

IMHO Having a function to deal with the overflow of a multiplication and
then do an allocation based on the result is a conflation of two different
things that need to be separate. kcalloc only exists because there is
an ancient user space function that somehow got a second parameter instead
of just using the same as malloc().



