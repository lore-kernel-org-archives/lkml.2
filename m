Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2ARNfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:35:14 -0500
Received: from mga07.intel.com ([143.182.124.22]:22406 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757397Ab2ARNfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:35:12 -0500
MIME-Version: 1.0
In-Reply-To: <26583.1326890996@redhat.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184548.21874.69507.stgit@warthog.procyon.org.uk>
	<CALLzPKbQb26jAqkkduSQGDDtFuNiCDf5F-HVYB-RJjF4+KLLeQ@mail.gmail.com>
	<26583.1326890996@redhat.com>
Date: Wed, 18 Jan 2012 15:34:48 +0200
Message-ID: <CALLzPKb6v-F-Hh+TAifQyABb3TrSRy5Th8kc-3W48pykEoTc-Q@mail.gmail.com>
Subject: Re: [PATCH 16/21] KEYS: PGP-based public key signature verification
 [ver #3]
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:49 PM, David Howells <dhowells@redhat.com> wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>
>> Synchronous hash SHASH is used only for software hash implementation...
>> HW acceleration is not supported by this hash.
>> It is good for short data.
>> But when calculating a hash over long data as files can be,
>> async hash AHASH is a preferred choice as enables HW acceleration.
>
> Indeed.  The asynchronous hash is a pain to use in the kernel, though, for a
> couple of reasons: kernel addresses don't necessarily correspond to addresses
> the h/w accel will see and you have to handle the h/w not signalling
> completion.  Herbert created shash to make it easier, and for module signing,
> they're perfectly sufficient.
>

Well, from client side, API is not that more complicate.
It is just about scatterlist. Rest is handled by particular driver/HW.

I agree, modules are not that big and SHASH is perfect choice for that...

>> As in my response to [PATCH 08/21] KEYS: Add signature verification facility
>> [ver #3] It would be nice to have API to pass pre-computed hash, then client
>> might tackle async peculiarities by itself...
>
> True.  If you can give me the completed hash data, then I don't need to care
> how you managed it.  If you give me an uncompleted hash, I then have to deal
> with the async hash in the kernel.
>
> It might make sense for me to provide an API call to give you the postamble you
> need to add to the hash to complete it.  That call could also indicate which
> hash you require and could also be combined with the call to find the
> appropriate key.
>

Indeed, some blob with metadata to update before closing the hash
would work well.

PS.. As I understand, it is PGP spec which requires such processing.
Otherwise, plain data hash could be used to produce another hash for signing,
similar to what has been done in digsig project.... I have used the
same approach for IMA.

Thanks!

> David
