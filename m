Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1LBAvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:51:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1LBAv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:51:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
References: <20111201070052.GA29708@july> <4ED7FA81.9090802@redhat.com> <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 1 Dec 2011 19:50:58 -0500
Message-ID: <CAGpXXZL3CuZj2KmjiYrHNivqesBtVxzq=ZxGHkDPeYVD_tW_Xw@mail.gmail.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
To: Kyungmin Park <kmpark@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, tm@tao.ma, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 7:01 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On 12/2/11, Eric Sandeen <sandeen@redhat.com> wrote:
<snip>
> Hi,
>
>> Hm, so if there were freed but un-trimmed blocks at this point, we will
>> never trim them until we free _another_ block in the group, right?  That
>> might be a reasonable tradeoff, but it is somewhat surprising behavior.
>>
>> i.e. say we do:
>>
>> mount /mnt
>> rm -rf /mnt/very_big_file
>> umount /mnt

does umount need to force a fitrim if it's available?

>> mount /mnt
>> fitrim /mnt

That way if umount is clean, then the new logic could kick for the
next mount, but if there was not a clean umount, then in addition to
replaying the journal, the next mount could leave the fitrim info not
initialized.

I'm sure there are smarter ways to track it.  The biggest thing I'm
suggesting is for there to at least be a single boolean "fitrim'ed
state flag for the whole filesystem.  that could cleared on mount and
set on a clean umount.

Greg
