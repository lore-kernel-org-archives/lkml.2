Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1DORKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:10:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab1DORKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110413155150.984826556@clark.kroah.org>
References: <20110413155406.GA22568@kroah.com> <20110413155150.984826556@clark.kroah.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 10:10:13 -0700
Message-ID: <BANLkTikJDeYPAFeei6DtKPcfvxP1ZeiQaQ@mail.gmail.com>
Subject: Re: [74/74] net: fix rds_iovec page count overflow
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 8:51 AM, Greg KH <gregkh@suse.de> wrote:
> +
> +               /*
> +                * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
> +                * so tot_pages cannot overflow without first going negative.
> +                */
> +               if ((int)nr_pages < 0)
> +                       ret = -EINVAL;
> +                       goto out;
>        }

Yeah, what the heck happened there. That won't work.

As Paul says, the original was just a "return -EINVAL", and when the
backport changed it into a "ret = " + "goto out", it really needs a
couple of braces.

As it is, the patch is just broken. Think about it.

                                  Linus
