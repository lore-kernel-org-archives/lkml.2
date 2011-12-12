Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1LLWrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:47:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61622 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1LLWrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:47:39 -0500
MIME-Version: 1.0
In-Reply-To: <20111212215818.GP3366@decadent.org.uk>
References: <1319461948.31243.31.camel@deadeye> <CAB=NE6Vt91tHCBj7sJHjUCaDZZPqox+omcQjsEj54vQAtbY2bw@mail.gmail.com>
 <20111212215818.GP3366@decadent.org.uk>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 12 Dec 2011 14:47:14 -0800
X-Google-Sender-Auth: kkrGuuYfBN687rc-zBIkc8oJ_vM
Message-ID: <CAB=NE6Wb9ySk6a1gB-edyF_uRe=-ESehUNbUa+n0g2WYGJXnqw@mail.gmail.com>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 1:58 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, Dec 12, 2011 at 01:40:44PM -0800, Luis R. Rodriguez wrote:
>> On Mon, Oct 24, 2011 at 6:12 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > Use of the GPL or a compatible licence doesn't necessarily make the code
>> > any good.  We already consider staging modules to be suspect, and this
>> > should also be true for out-of-tree modules which may receive very
>> > little review.
>> >
>> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> > ---
>> > Debian has been carrying this for the last few kernel versions.  The
>> > recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
>> > that this might be more generally useful.
>>
>> This indeed seems like a good idea to advocate getting things upstream
>> (not just staging) but what about the case where we have upstream
>> drivers from future kernels backported to older kernels and the newer
>> driver is simply provided as a feature for users who may need new
>> features / chipset support on their old distribution kernel?
>
> They continue to work without any loss of functionality.  (After the
> follow-up patches to keep dynamic debugging and lock debugging
> working.)

Great!

>> It seems this taint flag will be used for driers backported through
>> compat-wireless, the compat kernel module or any other backported
>> driver, even if it is indeed upstream and whereby kernel developer
>> *do* commit to actually fixing issues. In our experience
>> compat-wireless bugs *are real bugs*, not backport bugs so we do look
>> into them. In our latest linux-next.git based release for example
>> backport code consists only of 1.3804% of the code.
>
> Now you can look for (O) after the module name in a BUG/Oops message
> and you can tell whether the user really had the original or
> compat-wireless version of the driver.
>
> It is really up to each distributor or developer how they treat
> bug reports with the O taint.  When handling Debian bug reports I
> won't automatically reject such a tainted kernel but I will look
> carefully at the module list.

I'm working on getting my companies to abandon 802.11 proprietary
drivers for good. For Station mode of operation this is pretty much
mission complete. For AP products.. this is work in progress. The out
of tree flag is a good utility one can use to help justify working
upstream but if we treat any future-kernel-backported-driver equally
to any out of tree crap piece of shit driver, it seems to do unjustice
to the value of a properly upstream backported driver. I will note
that I put a lot of effort to ensure that the backport effort is
upstream-centric in an *extremely* upstream-biased way, see how I
label extra patches for tarballs [1]. If your patches are not upstream
the only way you get into these tarballs are by providing patches into
these directories:

  * pending-stable/ stable fixes from linux-next.git not yet on a stable release
  * linux-next-cherry-picks/ patches upstream but that won't go to the
stable release that we want to cherry pick
  * linux-next-pending/ patches posted on the public development
mailing list, patch not yet merged due to the maintainer being away on
vacation or whatever
  * crap/ patches not even posted publicly yet

Each tarball used also gets pegged with a letter if *any* patch from
any of these directories gets applied. The compat module, upon being
loaded, will also print the kernel ring buffer the exact release,
whether extra patches were provided, the upstream git tree used as
base and so on.

So -- although from a technical perspective this may mean Debian /
other kernel developers may ignore the taint flag for compat-wireless
it'd sure be nice to avoid it for them all together. Just can't think
of a way to do it yet... If you agree should we continue to think of a
way if its possible?

[1] http://wireless.kernel.org/en/users/Download/stable#Legend

  Luis
