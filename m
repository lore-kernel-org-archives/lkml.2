Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1AaWfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:35:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54860 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1AaWfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:35:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gGPNuBswxQhIys/5Bvf4yz/pso9u3q8XcVu96DOGJ4+SZvLDLP7bsnMimW69GPgPrF
         XDesd4lOzm/j6OMomQXgKBeViNvH3u/1E0cgQMtKJM2N56KIHg55yOqwq7aJqZXR6Jnz
         K083PTLxZX6umJELC2OX7vM0tkfkRDB5XNZ4M=
MIME-Version: 1.0
In-Reply-To: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
References: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw>
	<AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com>
	<AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
Date: Mon, 31 Jan 2011 14:35:31 -0800
Message-ID: <AANLkTini7Hx6dbTAKJKJy=NnC+LFcQuHEsayxwJJ78-+@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio: add devicetree support
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Chou <thomas@wytron.com.tw>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 31, 2011 at 12:09 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Sun, Jan 30, 2011 at 8:26 PM, Håvard Skinnemoen
> <hskinnemoen@gmail.com> wrote:
>> Hi,
>>
>> On Sun, Jan 30, 2011 at 7:56 AM, Thomas Chou <thomas@wytron.com.tw> wrote:
>>> From: Albert Herranz <albert_herranz@yahoo.es>
>>>
>>> This patch is based on an earlier patch from Albert Herranz,
>>> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
>>> 9854eb78607c641ab5ae85bcbe3c9d14ac113733
>>
>> That commit has a single-line description of which I don't understand
>> a single word (unless "wii" is what I think it is, which seems
>> likely). Could you please explain how that commit relates to this
>> patch?
>
> The URL got wrapped.  Try this one (assuming my mailer doesn't wrap it):
>
> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/9854eb78607c641ab5ae85bcbe3c9d14ac113733

Ok, that seems to be a _bit_ more related, but not that much. I'd
really prefer a patch description which can stand on its own.

>>> The dts binding is modified as Grant suggested. The of probing
>>> is merged inline instead of a separate file. It uses the newer
>>> of gpio probe.
>>
>> It seems like a terrible idea to merge firmware-specific code into the
>> driver. Is there are reason why of-based platforms can't just pass the
>> data they need in pdata like everyone else?
>
> Overall Thomas is doing the right thing here.  The driver data has to
> be decoded *somewhere*, but since that code is definitely
> driver-specific (as opposed to platform, subsystem, or arch specific)
> putting it into the driver is absolutely the right thing to do.  Quite
> a few drivers now do exactly this.

Ok, I'm convinced that this is the right thing to do.

> It is however generally a wise practice to limit the of-support code
> to a hook in the drivers probe hook, and as you point out, care must
> be taken to make sure both CONFIG_OF and !CONFIG_OF kernel builds
> work.
>
>>
>> Not saying that it necessarily _is_ a terrible idea, but I think the
>> reasoning behind it needs to be included in the patch description.
>
> Nah, he doesn't really need to defend this since it is a well
> established pattern.  device tree support is in core code now (see
> of_node an of_match_table in include/linux/device.h), and other
> drivers do exactly this.

Well, perhaps you're right, but I still think the patch description is
a bit on the thin side. In particular, terms like "as Grant suggested"
isn't very helpful for people like me who don't know what you
suggested (even though I'm sure it was a good suggestion).

I think the patch lacks a good description of what's being changed and
why. The references may be nice to have as a supplement to that, but
describing things entirely in terms of some unknown e-mail discussion
that happened earlier is not very helpful for people who want to
figure out what's going on a couple of months or years from now.

Havard
