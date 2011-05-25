Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1EYNWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:22:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57347 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab1EYNWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=or5vWu4NIaiRN4njD+QeF2bDecYUscD7LVwHaFUcvR+kKMzMxV3ojkCeKmynsQLMUD
         PYwYsTqBpMWuYKFqoCvS4sCXA/WlmtluVeZKaykwebL3dMOhXBxjjT81ReZ0TOeXOtQV
         RYOpC6LqfpolLelaX449kkh12L+BUpx4ppYlQ=
MIME-Version: 1.0
In-Reply-To: <20110525093308.GA11521@ZenIV.linux.org.uk>
References: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
	<20110525093308.GA11521@ZenIV.linux.org.uk>
Date: Wed, 25 May 2011 21:22:39 +0800
Message-ID: <BANLkTikWjHK-=BGNzEhDJWg-Qv7-EOO6Lg@mail.gmail.com>
Subject: Re: vfs: where is get_sb_single()?
From: Bob Liu <lliubbo@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 5:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, May 25, 2011 at 03:19:58PM +0800, Bob Liu wrote:
>> Hi, folks
>>
>> I found that fs/super.c doesn't have get_sb_single() anymore.
>>
>> But I can't find the git log which delete that function.
>> Some out of tree file systems depends on that function.
>
> The same out of tree filesystems depend on ->get_sb() being there...
> See Documentation/filesystems/porting:
>
> [mandatory]
>        ->get_sb() is gone.  Switch to use of ->mount().  Typically it's just
> a matter of switching from calling get_sb_... to mount_... and changing the
> function type.  If you were doing it manually, just switch from setting ->mnt_root
> to some pointer to returning that pointer.  On errors return ERR_PTR(...).
>
> IOW, odds are good that you'll need to do something like what had been
> done in commit 152a08366671080f27b32e0c411ad620c5f88b57 - not terribly
> complicated.
>

Got it, Thanks a lot for your help.

I made a mistake during browser linux-next.git in kernel.org.

-- 
Regards,
--Bob
