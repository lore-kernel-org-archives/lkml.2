Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1J3USN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:18:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51425 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1J3USM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:18:12 -0400
Message-ID: <4EADAF69.80008@zytor.com>
Date: Sun, 30 Oct 2011 13:11:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Kyle Moffett <kyle@moffetthome.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: Detecting if you are running in a container
References: <20111011013201.GA7948@thunk.org> <20111011020530.GG16723@count0.beaverton.ibm.com> <20111011032523.GB7948@thunk.org> <m1ty7ghvvn.fsf@fess.ebiederm.org> <203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu> <m17h4bfcuv.fsf@fess.ebiederm.org> <20111012175702.GA23231@fieldses.org> <CAGZ=bqJxadNqaPCW3HufrMmQ57x082=pCDa6-mWLsdtfxHgdPw@mail.gmail.com> <20111012190452.GA23845@fieldses.org> <CAGZ=bqJjgmtBfyXJ2eK1C0PfzkgBVWFTjkTYkC211ZT+-5f-UQ@mail.gmail.com> <20111014155406.GC13119@thunk.org> <m17h478n5k.fsf@fess.ebiederm.org> <4E98B088.5030400@zytor.com> <m1ipnpl1c9.fsf@fess.ebiederm.org>
In-Reply-To: <m1ipnpl1c9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 02:42 AM, Eric W. Biederman wrote:
>>
>> Something based on UUIDs, perhaps?
>>
>> UUIDs are kind of exactly this, after all... a single namespace designed
>> to be large and random enough to be globally unique without a central
>> registration authority.
> 
> mount --bind /proc/self/ns/net /var/run/netns/<name>
> 
> When we want to refer to the namespace in syscalls we pass a file
> descriptor we received from opening the namespace reference object.
> 
> That moves the entire naming problem into the file namespace.
> 

That doesn't solve what I think of as the *real* problem.

The real problem is just another instance of what I sometimes refer to
as the "alien metadata problem": the alien metadata problem (which crops
up in *all kinds* of contexts, including containers, namespaces, virtual
machines, building distribution disk images, and backups) is the fact
that you would like to be able to store, manipulate and preserve, on
disk and in a mounted filesystem, a set of metadata which may not be the
"currently active" metadata.

There are two forms of "solutions" to this: one where the filesystem
still only contains one set of metadata, but it is not currently active,
and one where the filesystem contains multiple sets of metadata for the
same files at the same time, any one of which can be active (and
different ones may be active for different namespaces.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

