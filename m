Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1D0Ec7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:32:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50983 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1D0Ec5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GIUfgkh6ZpYTNoPg0PYJ47+nhHvk74QHGUMxTfpO99D6um8ZBt/p4y+KVCK7DZSfUZ
         g4oIxjMYV71EfwxMYctplDh8y6qDPmOVDjR3+L4u+gI9BjETqxBwL279vFIkOrd3htuY
         9AZimF3IjKCfmy7ZiEzdQe4KRa7zuVj+yxw+o=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <1303878240.2699.41.camel@edumazet-laptop>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 06:32:51 +0200
Message-ID: <1303878771.2699.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 06:24 +0200, Eric Dumazet a écrit :

> We had similar reports in the past that disappeared when adding
> "slab_nomerge" to boot parameters. We suspect a memory corruption from
> another part of kernel on 64bytes kmemcache objects.
> 
> In 2.6.37, inetpeer code uses 64bytes objects. Using slab_nomerge and
> SLUB allocator (as you already do), makes sure inetpeer kmemcache wont
> be shared by other 64bytes objects in kernel.
> 

Of course, the right option name is slub_nomerge

vi +2293 Documentation/kernel-parameters.txt

        slub_nomerge    [MM, SLUB]
                        Disable merging of slabs with similar size. May be
                        necessary if there is some reason to distinguish
                        allocs to different slabs. Debug options disable
                        merging on their own.
                        For more information see Documentation/vm/slub.txt.



