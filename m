Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0FSUU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:20:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39018 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0FSUUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kYpnbx8sDs4C0j3SAd91w60cPbAEUxXIcdMorFDxz3/KKAKKkfvQQO+ZnIzxD/Hgng
         BiUDzfES6/qhnqymhA73/OuBfbbK9kqF+LPBPwIT7TMhoDpoS1Q+GsGTBZ2uoWJW8m8D
         GxmTh5YNo5bGUCPwevQ0sBl9xuPsdvCIH3Yqw=
MIME-Version: 1.0
In-Reply-To: <87k4pvo16d.fsf@basil.nowhere.org>
References: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
	<87k4pvo16d.fsf@basil.nowhere.org>
Date: Sun, 20 Jun 2010 04:20:54 +0800
Message-ID: <AANLkTikSD70wX4eBi6GZyOSqL478dmT8_eEmYzz9zzk9@mail.gmail.com>
Subject: Re: idea about internal fragmentation in Btrfs
From: Zhihui Zhang <zzhsuny@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes perfect sense. No wonder some btrfs folks used to work on
reiserfs/4. I hope a solution can be or has been found.

On Sat, Jun 19, 2010 at 4:51 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Zhihui Zhang <zzhsuny@gmail.com> writes:
>
>> I wish Btrfs well, so I would venture an idea for this specific case
>> mentioned by Edward Shishkin today.
>>
>> Everyone knows that B-tree has internal and leaf nodes.  Can we make
>> the root as the leaf?  In other words, if you
>> create a 2K file, the B-tree will have only one node, which is both
>> the root and the leaf. Of course, you need some flag to
>> say this is a "degenerated" form of B-tree. Please cc me if you want
>> my response.
>
> You need to copy linux-btrfs to reach btrfs developers.
> Ccs added
>
> The problem with your idea is that on btrfs there's only
> a single tree for the whole fs (or whole snapshot rather)
> So it would only work for a single file because there's
> only a single root.
>
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
>
