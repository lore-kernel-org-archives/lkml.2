Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2GSQBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:01:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2GSQBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:01:22 -0400
Message-ID: <50082F44.7070500@suse.cz>
Date: Thu, 19 Jul 2012 18:01:08 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Borislav Petkov <bp@amd64.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic> <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon> <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm> <20120716082418.GC24327@aftab.osrc.amd.com> <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm> <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com> <alpine.DEB.2.02.1207161222380.32545@asgard.lang.hm> <CA+55aFw7zdyPpDEdpDbYWc-Z++v_kDQHD3Z+-QwPszh+9bU+tQ@mail.gmail.com> <CAMuHMdWopF1MjHjNT_CAnu=pTU8X8oxyW4M+y2-XHEHfF2XHhg@mail.gmail.com>
In-Reply-To: <CAMuHMdWopF1MjHjNT_CAnu=pTU8X8oxyW4M+y2-XHEHfF2XHhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.7.2012 10:03, Geert Uytterhoeven wrote:
> On Mon, Jul 16, 2012 at 10:56 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Jul 16, 2012 at 12:26 PM,  <david@lang.hm> wrote:
>>> Some of the proposed ways to implement the minimum distro kernel would not
>>> allow you to override the distro defaults because they would be implemented
>>> by setting dependancies, not by selecting options that you as the user could
>>> then unselect.
>>
>> The sanest thing to do is just a list of "select" statements. And in
>> any case it would have to depend on the "distro config" entry, so EVEN
>> THEN you could just create the Kconfig file, then edit out the distro
>> config thing, and then do whatever you want.
> 
> Except that "select" is one of the ugliest things in Kconfig, as it
> blindly sets a symbol
> without checking if its dependencies are fulfilled.

But for the few options Linus proposed (TMPFS, TMPFS_POSIX_*,
DEVTMPFS(_MOUNT)), the amount of additional dependencies is reasonable.
For something more advanced like 'build me a kernel for a laptop with
$VENDOR hardware', we would need a better dependency solver, indeed.

Michal
