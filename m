Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1AMOLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:11:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63670 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab1AMOLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:11:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EChqCKbIlTr7k1CtrKGOoWuaMs+xpntQ/DweS7huyaAw8hOewoENN9MOuhQc+HMPOE
         y1gBjnWy5sxHokyv78+mEoSRNf4n45YoBtm0N9SnIjLGP5TZ1Ix+pAFP+cVPdHtGLEGe
         EwhX3uVcxrL9E6fQxJl9BH4yYMFsp3Ax3oi4g=
Date: Thu, 13 Jan 2011 15:11:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113141107.GI30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F04FF.1070309@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 02:58:23PM +0100, Milan Broz wrote:
> On 01/13/2011 02:37 PM, Tejun Heo wrote:
> 
> > So, just don't do it.  Sysfs is for device hierarchy.  Don't try to
> > shove pretty looking things there (unless it's something widely agreed
> > on and necessary, of course).
> 
> I think that it is exactly what holders/slaves do - displaying device
> hierarchy. So application can check which underlying device are related
> and ask them for more info if needed (=> with system specific call,
> it can be simple sysfs attribute, ioctl, whatever).

Yeah, sure but in a completely unrestrained and non-standard way.
First of all, it wasn't even necessary to begin with and I don't
really see anyone else other than md/dm using it.  I mean, where are
you gonna you put that slaves directory?  Sure you can put it
somewhere but really it would be just that - somewhere.  All this
doesn't even matter.  It wasn't even necessary to begin with.

> So the only request here is to keep these symlinks correct, nothing more.
> Or am I missing anything?

Yeah, I'm fixing that.  Don't worry.  I just wanna say it wasn't such
a brilliant idea to add it in the first place and hope that people
would restrain from doing similar things in the future.

So, as a general rule, when in doubt, just create an attribute.  Let's
refrain from custom symlinkery in sysfs, please.  In this case too, a
holder attribute containing strings like ext[3|4], md, dm or whatnot
would have been _much_ simpler and actually more useful.

Thank you.

-- 
tejun
