Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893Ab0HLEEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 00:04:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63667 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0HLEEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 00:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPgk8HFeG4MXq/rSlsUR1fX/FJAlWUyBR92NQqzRi35dfCp6IEKpjxy67wlX3f6dFc
         CFcNapE4HxhzMK9Hd5nxyRjJWruoQGGzTmw5CR5AyVgDTaKXMKi0lOvv0QGzsHjaWQUa
         /QUp/QpAqTp7oDwzzTn6u3GeAE621RWaHU75s=
MIME-Version: 1.0
In-Reply-To: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
Date: Wed, 11 Aug 2010 23:04:36 -0500
Message-ID: <AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/dns_resolver/dns_key.c: In function 'dns_resolver_instantiate':
> net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:99: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:128: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:136: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:143: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:144: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:149: error: implicit declaration of function 'key_payload_reserve'
> net/dns_resolver/dns_key.c:162: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c: In function 'dns_resolver_match':
> net/dns_resolver/dns_key.c:178: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c: In function 'dns_resolver_describe':
> net/dns_resolver/dns_key.c:211: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:213: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c:217: error: dereferencing pointer to incomplete type
> net/dns_resolver/dns_key.c: At top level:
> net/dns_resolver/dns_key.c:220: error: variable 'key_type_dns_resolver' has initializer but incomplete type
> net/dns_resolver/dns_key.c:221: error: unknown field 'name' specified in initializer
> net/dns_resolver/dns_key.c:221: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:221: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:222: error: unknown field 'instantiate' specified in initializer
> net/dns_resolver/dns_key.c:222: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:222: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:223: error: unknown field 'match' specified in initializer
> net/dns_resolver/dns_key.c:223: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:223: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:224: error: unknown field 'revoke' specified in initializer
> net/dns_resolver/dns_key.c:224: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:224: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:225: error: unknown field 'destroy' specified in initializer
> net/dns_resolver/dns_key.c:225: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:225: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:226: error: unknown field 'describe' specified in initializer
> net/dns_resolver/dns_key.c:226: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:226: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c:227: error: unknown field 'read' specified in initializer
> net/dns_resolver/dns_key.c:227: warning: excess elements in struct initializer
> net/dns_resolver/dns_key.c:227: warning: (near initialization for 'key_type_dns_resolver')
> net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
> net/dns_resolver/dns_key.c:237: error: invalid use of undefined type 'struct key_type'
> net/dns_resolver/dns_key.c:249: error: implicit declaration of function 'key_alloc'
> net/dns_resolver/dns_key.c:249: error: 'key_type_keyring' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:249: error: (Each undeclared identifier is reported only once
> net/dns_resolver/dns_key.c:249: error: for each function it appears in.)
> net/dns_resolver/dns_key.c:250: error: 'KEY_POS_ALL' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:250: error: 'KEY_POS_SETATTR' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:251: error: 'KEY_USR_VIEW' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:251: error: 'KEY_USR_READ' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:252: error: 'KEY_ALLOC_NOT_IN_QUOTA' undeclared (first use in this function)
> net/dns_resolver/dns_key.c:258: error: implicit declaration of function 'key_instantiate_and_link'
> net/dns_resolver/dns_key.c:262: error: implicit declaration of function 'register_key_type'
> net/dns_resolver/dns_key.c:268: error: 'struct cred' has no member named 'thread_keyring'
> net/dns_resolver/dns_key.c:269: error: 'struct cred' has no member named 'jit_keyring'
> net/dns_resolver/dns_key.c: In function 'exit_dns_resolver':
> net/dns_resolver/dns_key.c:285: error: implicit declaration of function 'unregister_key_type'
> net/dns_resolver/dns_key.c:288: error: invalid use of undefined type 'struct key_type'

> Presumably this code has not been built on powerpc before.  Casued by
> commit 1a4240f4764ac78adbf4b0ebb49b3bd8c72ffa11 ("DNS: Separate out CIFS
> DNS Resolver code") (and the build was probably enabled by commit
> c2e8139c9f797baa46515af6d350c51823736cbb ("NFS: Use kernel DNS resolver
> [ver #2]").
>
> I can only imagine that linux/key.h is included indirectly on x86.
Are you sure that this is a valid config file?  CONFIG_KEYS should be
set if CONFIG_DNS_RESOLVER is set?

key.h looks like it is included in all arch in this path

net/dns_resolver/dns_key.c includes
include/keys/dns_resolver-type.h which includes
include/linux/key-type.h which includes
include/linux/key.h

the line 258 "key_instantiate_and_link" error could occur if
"CONFIG_KEYS" is not set in .config
net/dns_resolver/Kconfig config DNS_RESOLVER "depends on NET && KEYS"
so ... CONFIG_KEYS should be set ....







-- 
Thanks,

Steve
