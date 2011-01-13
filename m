Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab1AMQKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:10:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab1AMQKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QCKJANMbLEbxPTlJ5Lf1J1p16pVndYZfdkh74jSTWL28R7AT/G+L6Yy7hEZg1woPfx
         ODUFXYDaJAQdDp0d0b6+M7EXG5AnV+s71HVeOQHp2uy79R+LAgZYHY34OjRXzEKPhbw6
         3s5fz75NICaynai7uYiJkouPxVOl9bi3ZHMzA=
MIME-Version: 1.0
In-Reply-To: <20110113155955.GI16523@nb.net.home>
References: <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com> <20110113155955.GI16523@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 13 Jan 2011 17:10:02 +0100
Message-ID: <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
To: Karel Zak <kzak@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 16:59, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
>> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
>> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
>> >> Maybe, but this was not invented in DM/MD camp:-)
>> >> Probably Kay or Greg can answer why it was done this way?
>>
>> It's not from Greg or Kay. It just appeared some day in the context of dm. :)
>>
>> And yes, symlinks *look* nice and simple for the outside, but they are
>> not, and have all sorts of problems like non-atomic updates, make it
>
>  Sounds like sysfs implementation problem, right?

It's a normal multi-file problem. It can by-definition not be atomic
without doing really weird locking things.

>  If there is noway to fix sysfs then we can add a generic ioctl or
>  /sys/block/<device>/{slave,holder}_list files with list of
>  holders/slaves.

Yeah, we've been there with the btrfs problem. For btrfs it woud
probably need to be something statfs()-like.

>  But please, don't force userspace to use *claimer-specific*
>  methods to answer *generic questions* like slave/holder dependencies
>  between devices.

The links exist only for dm and md so far, I think. It's the classical
multiple-parents-in-a-tree problem. We have that for bonded network
devices and some IO buses too. There is no nice representation for
these reversed-trees-in-the-tree so far.

Kay
