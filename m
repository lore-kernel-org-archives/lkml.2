Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2KGQQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:16:24 -0500
Received: from canardo.mork.no ([148.122.252.1]:43800 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab2KGQQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:16:22 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
Organization: m
References: <50899507.1040900@oracle.com>
	<20121026143754.50277bd8@pyramind.ukuu.org.uk>
	<CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
	<20121105175937.26f31d2a@pyramind.ukuu.org.uk>
	<5097FEA9.2090603@oracle.com>
	<alpine.LNX.2.00.1211051106590.1709@eggly.anvils>
	<20121105201507.79fe47d7@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1211051231070.21645@eggly.anvils>
	<20121106161100.216c6d79@pyramind.ukuu.org.uk>
	<20121106164214.GA18246@redhat.com>
	<20121106173845.4a50d661@pyramind.ukuu.org.uk>
	<509A665C.3030603@gmail.com>
	<20121107160232.18e83ee9@pyramind.ukuu.org.uk>
Date: Wed, 07 Nov 2012 17:15:45 +0100
In-Reply-To: <20121107160232.18e83ee9@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Wed, 7 Nov 2012 16:02:32 +0000")
Message-ID: <87625h9yoe.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> +
> +static int bind_con_driver(const struct consw *csw, int first, int last,
> +			   int deflt)
> +{
> +	int ret;
> +	
> +	console_unlock();

console_lock() maybe...

> +	ret = do_bind_con_driver(csw, first, last, deflt);
> +	console_unlock();
> +	return ret;
> +}
> +	


Bjørn
