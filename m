Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0GIV0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:26:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43061 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0GIV0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rX0NKQnx9jwCCcJIm07tYpUA3WQMT9Kw+PnoFVrEJZgYH/jSEK+SXai/LOoxz1U7Rx
         o4wxT+TLvSg3xssMRxLUiyovVln7aKNGn4HixjKQPWk3karqMA2PVtfFNG6LxmjV/dgv
         uzHY66bWeg3cdOoy4To4ahv2W9yKvP7/mLxpU=
MIME-Version: 1.0
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C3CF4C5@nsmail.netscout.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
	<82tyo9i0n2.fsf@mid.bfk.de>
	<D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
	<AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B90C3CF4C5@nsmail.netscout.com>
Date: Fri, 9 Jul 2010 14:26:30 -0700
Message-ID: <AANLkTilYZTwekbqKCXEaT6Yo3UTDl9tRHJlRdwpSg_IH@mail.gmail.com>
Subject: Re: nic enumeration
From: Steve Fink <sphink@gmail.com>
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Florian Weimer <fweimer@bfk.de>, linux-net@vger.kernel.org,
       Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 11:23 AM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
>> -----Original Message-----
>> From: Steve Fink [mailto:sphink@gmail.com]
>>
>> Soft (symbolic)
>> links are a filesystem concept, implemented by filesystem-specific
>> logic that knows how to read a filename out of an inode and restart
>> lookup. In order for something similar to work for network devices,
>> somebody would have had to explicitly implement similar functionality.
>> (Symlinks are a big headache and source of security holes -- access
>> control, loops, pointing to nonexistent files, etc. -- so there's a
>> good reason to NOT have an equivalent for network devices.)
>>
>
> Huh? If the 'ethX' interface doesn't exist just don't create the 'link'.
> So are you saying there are no security issues with udev-symlinks for
> other subsystems? Why is renaming allowed on the network-interface then?
> Isn't that a problem? I don't see the driver re-registering their RX/TX
> queues with the new-if-name.

The issues are different between network device and filesystem names,
yes. I was just saying that symbolic linking / aliasing are tricky.
udev symlinks introduce no *new* security issues because they're
filesystem links. Renaming the network interface certainly does cause
problems. And I don't know how the queues are connected to the devices
internally, but I doubt it's by name.

> May be I'm overlooking at something really obvious. But how are people
> managing [pv]drivers with multiple vNICs in their VMs if they need a
> consistent naming scheme?

Your problem is different from the one that began this thread. Can you
describe your situation more fully?

I only partially understand your problem, but I am still wondering if
my bridge idea would work for you. (Preferably combined with udev
rules or whatever so the bridges are unnecessary after the next
reboot.)
