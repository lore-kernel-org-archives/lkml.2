Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab1KHWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:17:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48533 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1KHWRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:17:21 -0500
MIME-Version: 1.0
In-Reply-To: <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
	<20111108203116.GF25083@aftab>
	<4EB9A6BC.7050600@zytor.com>
	<F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
Date: Tue, 8 Nov 2011 16:17:21 -0600
X-Google-Sender-Auth: gTePRiyWeYXvfZORGRdPd5GRioc
Message-ID: <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
Subject: Re: Geode LX boot fails after x86 microcode revision change
From: Daniel Drake <dsd@laptop.org>
To: "Petkov, Borislav" <Borislav.Petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 4:13 PM, Petkov, Borislav
<Borislav.Petkov@amd.com> wrote:
> This could definitely explain why it hangs, the rdmsr_safe call is
>  in early_init_amd(), so it could really be too early for exception tables.

I think this is almost certainly the cause too. The symptoms of this
issue are exactly the same as the early boot hang once discussed in a
thread titled "Dynamic nop selection breaks boot on Geode LX" (which
you wrote to as well) which was a problem of running code before
having exception tables set up.

I haven't yet run your tests except for "rdmsr 0x8b" which returns
"pread: Input/output error" - let me know if you would still like
results from the other tests.

Thanks
Daniel
