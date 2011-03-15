Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1COKQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:16:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1COKQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:16:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Date: Tue, 15 Mar 2011 11:15:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
References: <4D7F356C.8020903@cn.fujitsu.com>
In-Reply-To: <4D7F356C.8020903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151115.54426.arnd@arndb.de>
X-Provags-ID: V02:K0:a/Qim1aQGv0d6lv0LQVhziZg2RCs4Iw1HSTYuSQabfI
 I9ifsoBY+9aiiTwV6X7goDsW9w0/nghyn42/lBifbxWMhXyWZe
 p86QRuRcjg3Xkv//Vngt7nFw7EyoBY6V0NVjo8eYbyi39Kg72y
 lZP2A6G2NXSkASIjrEZaRREeZ3dBAT/eAZLK5/6ugrfv1rCjwR
 kaCNuIDBFGlOPObpTy4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011 10:46:20 Lai Jiangshan wrote:
> +static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
> +{
> +       return offset < 4096;
> +}

So this relies on the assumptions that 

a) the rcu_head is within the first 4 KB of the data structure to be freed
b) no callback ever gets called in the first 4 KB of virtual address space

It's probably a reasonable assumption, but I think it should be documented
more explicitly, especially the first one. It's entirely possible that
an RCU managed data structure is larger than 4 KB.
Another alternative might be to encode the difference between a
function pointer and an offset in one of the lower bits of the address.

	Arnd
