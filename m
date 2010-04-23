Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0DWKqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:46:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37727 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0DWKqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:46:44 -0400
Date: Fri, 23 Apr 2010 19:45:47 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][BUG][IMPORTANT] KEYRINGS: find_keyring_by_name()
 can gain the freed keyring
Message-Id: <20100423194547.3135efb8.toshi.okajima@jp.fujitsu.com>
In-Reply-To: <7894.1271931370@redhat.com>
References: <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
	<7894.1271931370@redhat.com>
Organization: Fujitsu co.,ltd.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Thanks for your comments.

David Howells wrote:
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
>> With linux-2.6.34-rc5, find_keyring_by_name() can gain the keyring which has
>> been already freed. And then, its space (which is gained by
>> find_keyring_by_name()) is broken by accessing the freed keyring as the
>> available keyring.
> 
> Good catch!
> 

> I'm not sure this is the best solution, though.
This means that the keyring of which the count became 0 should not usually 
be used again?
If yes, I think so, too.

> 
> The alternative is just to ignore keys that have a zero usage count.
OK. I applied your suggestion and I remade the patch.
Then I confirmed that the system with new fix could continue to work while
I was executing my reproducer and your reproducer.
[your reproducer]
> for ((i=0; i<100000; i++)); do keyctl session wibble /bin/true || break; done

So, I think my new patch is also fixed.
Please check it.(new patch is attached into the following mail.)

Thanks,
Toshiyuki Okajima
