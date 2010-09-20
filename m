Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0ITHoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:44:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65487 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0ITHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nTlwiiQHphQvPcp9qM4JKy9jJRhZ/6n5LqiTgLu/p/JqYnIUXVZkACHK3qxgg1qsXy
         8n1cviM7QTTzXFgT9a40179FYIGuCcpMBSouIY/+T4i10f37eMTQsObT1hTlsT/qJCbe
         sGdXQQflvBtcORS3/Dwx/G0ue0I1W2/7qok5Q=
Date: Mon, 20 Sep 2010 15:48:38 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rofail Qu <rofail@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: A simple question of sys_
Message-ID: <20100920074838.GB5503@cr0.nay.redhat.com>
References: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 02:58:30PM +0800, Rofail Qu wrote:
>How to use macro IS_ERR() ?
>
>It defines as,
>...
>#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>static inline long __must_check IS_ERR(const void *ptr)
>{
>	return IS_ERR_VALUE((unsigned long)ptr);
>}
>...
>so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
>valid address),
>IS_ERR() will return true!

NULL is not an error pointer, you missed the cast to unsigned long.


>IS_ERR(x) seems to use on judge if "x" is a valid error number, right?
>

Strictly speaking, it checks if 'x' is an error pointer.

