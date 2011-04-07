Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1DGPgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:36:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47541 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1DGPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KNH++jBTvrkKI7KEABLVhYFYTkdmpsXd8f2MGQAbWADun5Ub/zqZJj0g059Q2IcXI6
         f7SB0SNOmeV+nS8v9S1fwt2gMc3fy9izaavvUgKiNCV0L4RpvpaO06oo0VV61qIMN00i
         YYMzUMohOpR21n+E+RGrzRa7YA21k7SmSz6ck=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	 <1302177428.3357.25.camel@edumazet-laptop>
	 <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 17:36:26 +0200
Message-ID: <1302190586.3357.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 avril 2011 à 23:27 +0800, Changli Gao a écrit :

> azurlt, would you please test the patch attached? Thanks.
> 

Yes of course, I meant to reverse the patch

(use kmalloc() under PAGE_SIZE, vmalloc() for 'big' allocs)


Dont fallback to vmalloc if kmalloc() fails.


if (size <= PAGE_SIZE)
	return kmalloc(size, GFP_KERNEL);
else
	return vmalloc(size);



