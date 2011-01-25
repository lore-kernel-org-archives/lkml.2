Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AYBot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:44:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1AYBor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=daYsMynXlXQYXDXDZuUVTiy2AFKC+Y46E5XSoV9SwaBKMGth1e1IK8LI3SEzsMoRy0
         4CjBf7ZTw74inR1SKK//ERT1wajQYsb1iVmz4ng+NlMtwKGAGVNsiAcFaBLgh5wSnn0g
         wEuEl7nArEBBFbaoqm2al60t534G1TpEuDyr0=
MIME-Version: 1.0
In-Reply-To: <1295919258.1949.973.camel@sli10-conroe>
References: <1295915725.1949.967.camel@sli10-conroe>
	<AANLkTikOdiQR+rWXzoU9z5sJv9Q2=ehdhi1NCHXT0a-w@mail.gmail.com>
	<1295917864.1949.970.camel@sli10-conroe>
	<AANLkTimwSNsjR5PnVP8JvzwEBwy3VtDp4DvNecKsTnxJ@mail.gmail.com>
	<1295919258.1949.973.camel@sli10-conroe>
Date: Tue, 25 Jan 2011 12:44:45 +1100
Message-ID: <AANLkTikfxGF_4ZjJXP7kNChkDBnva5iStTPRLs3B86+c@mail.gmail.com>
Subject: Re: more dput lock contentions in 2.6.38-rc?
From: Nick Piggin <npiggin@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:34 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Tue, 2011-01-25 at 09:26 +0800, Nick Piggin wrote:
>> On Tue, Jan 25, 2011 at 12:11 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Tue, 2011-01-25 at 09:04 +0800, Nick Piggin wrote:
>> >> On Tue, Jan 25, 2011 at 11:35 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> >> > Hi,
>> >> > we are testing dbench benchmark and see big drop of 2.6.38-rc compared
>> >> > to 2.6.37 in several machines with 2 sockets or 4 sockets. We have 12
>> >> > disks mount to /mnt/stp/dbenchdata/sd*/ and dbench runs against data of
>> >> > the disks. According to perf, we saw more lock contentions:
>> >> > In 2.6.37: 13.00%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
>> >> > In 2.6.38-rc: 69.45%        dbench  [kernel.kallsyms]   [k]_raw_spin_lock
>> >> > -     69.45%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
>> >> >   - _raw_spin_lock
>> >> >      - 48.41% dput
>> >> >         - 61.17% path_put
>> >> >            - 60.47% do_path_lookup
>> >> >               + 53.18% user_path_at
>> >> >               + 42.13% do_filp_open
>> >> >               + 4.69% user_path_parent
>> >>
>> >> What filesystems are mounted on the path?
>> > ext3 or ext4
>>
>> ext3 or 4 along every step of the path? Are there
>> any acls loaded, or security policy running?
> all disks are formated with the same fs, just some machines use ext3 and
> others ext4. no we don't have acl or security policy.
>> It may be possible that they're all coming from
>> /proc/ access.
> I added trace in dput just after the lock taken. and most files are '/',
> 'mnt', 'stp'. the percentage of 'proc' is small actually.

Hm, OK well I could send you a patch to gather some statistics for
why rcu-walk gets dropped. It'll have to wait until I get home, though.
