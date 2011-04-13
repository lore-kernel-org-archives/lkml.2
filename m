Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1DMDxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:53:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47176 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab1DMDxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vTNOERkBuCASYSAYKBnP5rJp0TcoykVcYsxzJh/6f6bm5UmFLFw3KM8mxfqaSYyY3U
         R3O3wG8ZaD+vIEV1gTfLou9kCJYay3iq6WElHXw93cofZXGTz8/4JBt3KxN9xEpXZUwQ
         Z57s4nMFCvZNGecUipBbJ8XF+J4or69fMwU70=
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <1302663781.3981.169.camel@sli10-conroe>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <1302599035.3233.27.camel@edumazet-laptop>
	 <1302656465.3981.133.camel@sli10-conroe>
	 <1302661927.2811.18.camel@edumazet-laptop>
	 <1302662517.3981.161.camel@sli10-conroe>
	 <1302662853.2811.41.camel@edumazet-laptop>
	 <1302663781.3981.169.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 05:53:40 +0200
Message-ID: <1302666820.2811.115.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 13 avril 2011 à 11:03 +0800, Shaohua Li a écrit :
> I can do this, but please give a reason. If network code is the only
> place requiring disable irq, why not network code do it?
> 

Lot of percpu_counter users dont use full s64 range, but "unsigned long"
or "unsigned int". Adding a lock on 32bit arches to get the s64, then
truncate it is not needed.

This discussion reminds me an old one ;)

http://kerneltrap.org/mailarchive/linux-ext4/2008/12/12/4401894



