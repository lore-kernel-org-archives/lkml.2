Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab0IFUmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:42:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53687 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0IFUm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <4C853D69.2080108@gmail.com>
References: <272391166.1009231283787434910.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <169108422.1009631283788251084.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <AANLkTim=nf7VVs0zDshivjrdFFYeWaoWYqAA6PCs3c4k@mail.gmail.com> <4C853D69.2080108@gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 6 Sep 2010 16:42:07 -0400
Message-ID: <AANLkTi=kF880O_DuemgRPajvs3diyuvK8s4Ap04+kPzL@mail.gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
To: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Cc: Miloslav Trmac <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 15:13, Nikos Mavrogiannopoulos
<n.mavrogiannopoulos@gmail.com> wrote:
> On 09/06/2010 08:00 PM, Kyle Moffett wrote:
>>> The kernel keyring service is basically a system-wide data storage
>>> service.  /dev/crypto needs a quick way to refer to short-lived,
>>> usually process-local, kernel-space data structures from
>>> userspace.
>>
>> The problem with the approach you're proposing is that we then have
>> two entirely separate classes of keys.  First we have the existing
>> keyring class, which can be securely and revokably passed between
>> different processes with limited rights, but cannot be handed up to
>> the kernel's cryptoapi.
>
> I don't think this is the case. The NCR does not store any keys nor
> retrieves them. It does delegate the burden of that to userspace
> application. NCR exports a wrapped version of the key and the userspace
> application stores it. It could use the keyring to store the keys or
> could directly store them in the filesystem.

Hmm, I'm confused.  You say "The NCR does not store any keys nor
retrieves them", but ~75% of your API is specifically related to
storing keys into kernel memory or retrieving them out of kernel
memory.  Specifically, putting keys into and out of the kernel and
passing them around between processes is the *whole point* of the
keyring API.

So let me ask for some clarification:

You talk a lot in the patches about the API itself, but what is the
intended *use-case* for NCR?

Is it to provide a back-end for code such as enhanced-security OpenSSL
libraries?  For example, a privileged process would loads a key from
disk into the kernel, then fork the unprivileged SSL server process?

Is it just a canonical interface for userspace to encrypt or decrypt
data using the kernel's CryptoAPI?

Cheers,
Kyle Moffett
