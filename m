Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab1ANIwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:52:35 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:40664 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab1ANIw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:52:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pG7AZYGYeqvHKBGW3DOJz1JAil3iYZKQTY7AtlcMNGIjNVzofQ8ShvCD6+nfXOoWJx
         PdCqOBn5roE0kozzN+9kZz721LmVA2eR/YgeOhYOIO7CxhGi32MDIkFSdUDMgn6YFY+2
         UO26ygYXVUlVl/mC3PZeraTDxEwUERoPbKlTg=
MIME-Version: 1.0
In-Reply-To: <E1PdfI0-0005U7-LU@pomaz-ex.szeredi.hu>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<E1PdOdT-00042k-RM@pomaz-ex.szeredi.hu>
	<E1PdPsR-0004BY-Q3@pomaz-ex.szeredi.hu>
	<AANLkTi=4mCaZzGXja0Z_VBS+fst8k8_=t1A-eZwfvKiA@mail.gmail.com>
	<E1PdfI0-0005U7-LU@pomaz-ex.szeredi.hu>
Date: Fri, 14 Jan 2011 19:52:27 +1100
Message-ID: <AANLkTikVvaiqsj=ZiW4kN-CQB=oTuYpQQGH6+v6ZY1ny@mail.gmail.com>
Subject: Re: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 7:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, 14 Jan 2011, Nick Piggin wrote:
>> On Fri, Jan 14, 2011 at 3:18 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> Surely you'd need some filtering anyway? I don't think any function
>> involving path lookup could sanely return -ECHILD.
>
> No, but not filtering doesn't normally hurt.  And it's not quite
> trivial deciding what should be allowed and what shoudln't, and the
> filter would have to be updated for each addition of a new errno.  So
> I'm not sure I want to go there.

Well if you allow untrusted filesystems it is possible that
-ECHILD return will do something a bit silly. So it would be
good to filter it I guess.


>> That said, it probably is a good idea to have a new errno.
>
> Yeah, that makes the fitering much easier.

How so? Would -ECHILD ever be sane to return? I'm not
arguing against changing it but I just want to know what
the issue is there.
