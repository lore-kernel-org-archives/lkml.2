Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0DWIjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab0DWIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:39:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100422163633.de233f25.toshi.okajima@jp.fujitsu.com>
References: <20100422163633.de233f25.toshi.okajima@jp.fujitsu.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1][BUG][IMPORTANT] KEYRINGS: find_keyring_by_name() can gain the freed keyring
Date: Fri, 23 Apr 2010 09:39:04 +0100
Message-ID: <17087.1272011944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> #!/bin/sh
> 
> LOOP=100000
> USER=dummy_user
> # add
> /bin/su -c "exit;" $USER || { /usr/sbin/adduser -m $USER; add=1; }
> 
> for ((i=0; i<LOOP; i++))
> do
>         /bin/su -c "echo '$i' > /dev/null" $USER
> done
> 
> # del
> (( add == 1 )) && /usr/sbin/userdel -r $USER
> exit

Doing:

	for ((i=0; i<100000; i++)); do keyctl session wibble /bin/true || break; done

ought to work too.

David
