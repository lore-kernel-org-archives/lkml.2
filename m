Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1E3T7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:59:14 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43269 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1E3T7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lXH5SLerC3TyIcGm/c9lBZSF0kTnbH+zuSIyTJyXNlpx9LteNu1DSjVQfm33ZKURq/
         rZSdNVdh9/cjGzJpYStQzmtVrSuv/VHlvrrtWtopVhOYC2ppg7mTQ21LgQ+eOMMqV65D
         5Q6oosbYlPt3IxIz7CEY63LpxFXW1GU9SQEvw=
MIME-Version: 1.0
Date: Mon, 30 May 2011 15:59:12 -0400
Message-ID: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
Subject: Linux 3.0 change listings - Wonderful World of Linux 3.0
From: Joe Pranevich <jpranevich@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happy Memorial Day! I'm a day later than I said that I would be, but I
have attached a first draft of the "Wonderful World of Linux 3.0"
document. Please take a look and I hope that you find this helpful,
but I also hope that it can be a place that individuals not associated
with kernel development can turn to find out what is new in the
release. (With "new" being relative, of course. With no dev release,
these features have been available already.)

Good thing I didn't post it yesterday anyway, since I was still
calling it Linux 2.8. :)

Please take a look at this and let me know if I should make any
corrections. I appreciate your help. And feel free to mirror it
elsewhere. It has an "official website", but this is about information
sharing and not about driving traffic someplace. But include the link
so folks can get to the latest version if they like.

Joe

-----------

The Wonderful World of Linux 3.0

Joseph Pranevich – jpranevich <at> gmail.com

[ The latest edition of this document will always be found at
http://kniggit.net/wwol30 ]

--

Author's Note: This is WWOL30 draft #1, dated 5/30/11, aka the “Waking
Up From A Long Winter's Nap” edition. This is the first draft and so
there will be many bugs and typos and I appreciate any assistance in
squashing them. If you are interested in translating this document
into another language, please let me know. I would recommend not
beginning until the drafts stabilize, but that is up to you.

Note for web searches: At least for now, a “parody” WWOL30 will show
up above this one. That is an article, written in 1999, as part of an
event for a popular web comic. Don't be confused! Linux 3.0 really
does not support abacuses and the world didn't end on January 1, 2000.

--

It's been nearly eight years since the release to the world of Linux
2.6 and a tremendous amount has happened in the Linux world. While
Linux has not yet been successful in the desktop market, it has become
a system that even our metaphorical mothers are using thanks to its
commanding presence on smart phones (through Android) and on consumer
devices (such as Tivo). The world has changed since Linux 2.6.0, and
so has Linux.

This document describes just a few of the thousands of changes and
improvements that have been made to the Linux kernel since the launch
of Linux 2.6. I have attempted to make it as accessible as possible
for a general audience, while not shying away from technical language
when necessary.

An Important Note: Release Cycle

Perhaps the biggest change with the launch of Linux 3.0 may be how
small the impact will be for most Linux users. In previous release
cycles, Linux was developed using a two-branch process. One branch,
the even-numbered one, was considered “stable” and had few new
features added to it after release. The second branch was targeted for
“development” and while many new features would appear (and sometimes
disappear) there, users were warned against using that branch for real
work. This meant a delay, often of years, between when a feature was
placed in the development kernel and when it would be available to end
users.

No more. Linux 3.0 was developed using a new model, where there are
more frequent oscillations between unstable (“testing”) and stable
releases, directly on the 2.6 kernel tree. So even though Linux 3.0
represents a major upgrade, it also is the culmination in a long chain
of smaller releases. Most of the features which are new to Linux 3.0
have been available, in a stable form, for Linux users to enjoy for
some time.

Virtualization & Segmentation

One key change in the industry since the launch of Linux 2.6 has been
the mainstream adoption of virtualization. This technology allows for
the creation of virtual machines such that a Linux user is able to run
another copy of Linux or even Microsoft Windows “in a window” on their
desktop. Virtualization is not just a desktop technology: Large
organizations use virtualization to keep down hardware costs and
reduce downtime do to system failures. Linux 3.0 significantly
improves support for virtualization, both as a client and as a server.

The largest change in this area is the addition of the Kernel-based
Virtual Machine (KVM) system. This built-in virtualization allows most
Linux systems to run multiple operating systems without the need for
commercial software or to boot an alternative kernel first. KVM also
supports paravirtualization to allow Linux-on-Linux guests to run more
efficiently by not abstracting or emulating all aspects of the
underlying hardware and advanced memory deduplication across virtual
hosts. Normally, each virtual machine on a system has its own memory
space which is not shared. If there are several copies of Windows 7
running, for example, there will be several copies of the Windows core
features in memory at the same time. This feature allows Linux and KVM
to host more virtual machines than you have physical memory for, by
intelligently identifying areas which are identical between multiple
virtual machines and storing them only once. This enables significant
cost savings in many virtualization environments.

In addition to acting as its own virtual machine manager, or
hypervisor, Linux has made improvements to allow it to run better
inside of others' virtual machines. On the open source side, this
includes full support for running (in para- or fully-virtualized mode)
on top on the Xen hypervisor. But Linux also has improved support for
running on top of commercial virtualization systems such as VMWare,
including optimized network, storage, and graphics drivers. Linux even
supports modifying the amount of memory in a VMWare virtual machine on
the fly.

Closely related is the thinner Linux-on-Linux virtualization supported
by open source products such as OpenVZ. In these systems, the virtual
server simply runs as a locked-down process on the host server,
without having the overhead of a more complete implementation. In this
regard, Linux now supports multiple groupings and namespaces for
elements like processors, the process IDs, and many others. The
groupings allow something akin to process quotas for I/O and processor
activity: you can lock down a specific amount of processing to always
be given to a set of processes while loading everything else as
normal. The multiple namespaces means that those processes can even
see different views of the “local” system, such as different mount
points, or can prevent those processes from seeing ones outside their
group.

Linux 3.0's improved support for virtualization even extends to
hardware as Linux supports the I/O Virtualization standard used in
some PCI Express devices. With compatible hardware, a specific
physical device such as a network card can appear under Linux as
several devices, each of which can be assigned to processes or virtual
machines. While this can already be accomplished in software, Linux's
ability to do this directly on compatible hardware makes it a great
choice for server virtualization.

Clustering

On the opposite end from virtualization is clustering, the art of
bringing multiple servers together for a single task. While this
challenge is primarily solved on Linux outside of the kernel (using
projects such as the Apache Foundation's Hadoop), Linux 3.0 includes
significantly improved support for clustering storage including two
new cluster filesystems.

A cluster filesystem is one of the two key building blocks of cluster
storage. In short, this type of filesystem is designed to be run
against a block device which is shared between multiple hosts. This
could be done through iSCSI or another network block device protocol.
In this way, a cluster filesystem has some of the semantics of a
network filesystem in that multiple hosts can access the same data in
a safe way, but with other benefits such as redundant failover which
differ depending on the filesystem involved. Linux 3.0 includes two
major new cluster filesystems. The first of these, the Oracle Cluster
Filesystem (OCFS2) was, as its name implies, developed by Oracle and
was initially optimized for clustering Oracle databases but now works
well with other types of workloads. The second of the new filesystems
is the Global File System (GFS2), which has been developed and
supported by RedHat as part of their Enterprise Linux product..

The other key building block of a cluster filesystem is the ability to
share a block device, a disk, between multiple hosts. Linux already
supports several methods to share this data (including NBD, the
Network Block Device introduced in Linux 2.6), but Linux 3.0 adds one
more: the Distributed Replicated Block Device (DRBD). DRBD can be used
either to replicate a physical disk to a second host on the network,
as a backup, or as a sharing layer for cluster filesystems like the
ones described above.

Although this document only covers the aspects of the Linux kernel
which are not listed as “beta” or “experimental” in Linux 3.0, one key
technology to watch out for in upcoming versions is Ceph. This cluster
filesystem is a rising star for enterprise applications. Unlike the
simple disk-sharing filesystems described above, it can be scaled
across many systems and contains intelligence to ensure that a single
file will always be replicated multiple times within the storage pool.
You can easily scale a Ceph cluster just by adding a new host, and the
software dynamically redistributes the load and the data to the new
node. This prevents loss of data if a particular node is lost. Ceph
has been designed from the ground up for scalability and the early
reviews look pretty good, but it is still under development and not
yet recommended for production use.

Performance & Scalability

Even if you aren't doing virtualization or clustering, Linux 3.0's
overall performance is significantly improved for many workloads. This
is due in part to many rewrites across the board, but in particular
due to improvements in processor scalability and an overhaul of the
way that Linux delegates tasks.

Linux since 2.0 has been a multi-processor OS, but has retained some
legacy “features” which revealed its roots as a single-processor
system. One major obstacle to scalability was the “big kernel lock” or
“BKL”. This feature permitted kernel developers to block all of the
processors in the system so that one of them could do a particular
important task without risk of another stepping on its toes. As the
number of processors in systems have grown, this has moved from being
a minor inconvenience to a major performance bottleneck. Over the last
several revisions, Linux has been rewritten one subsystem at a time to
use finer-grained locks so that the necessity to block everything is
minimized. Linux 3.0 finally completes this work: the BKL is dead.
While this isn't the only obstacle to scalability, it is a major step.
Other improvements within Linux 3.0 has doubled the maximum number of
supported processors to 512.

Another way that Linux 3.0 has improved performance is with
adjustments to the scheduler. The scheduler is the component of Linux
that decides what processes on a system get how much cpu time. For
example, if you are a programmer you may want to ensure that your web
browser or email client does not run too slowly if you have a large
compilation going on in the background. The scheduler needs to decide
which task is most important and plan accordingly. The old scheduler
was consistently fair, but different users have different needs. Not
only does Linux 3.0 have a more robust default scheduler, it also
permits an administrator to change the scheduler to better reflect his
or her needs. No longer do users of desktop Linux have to use a
scheduler for servers or vice-versa. This scheduler has been improved
in other ways, as well. Linux now does a better job of understanding
multi-core and hyperthreaded processors, technologies that allow a
single physical processor to behave as two or more, and will delegate
tasks evenly across the real processors. The scheduler will also do a
better job of grouping and tuning related tasks together. This results
in an overall smoother feel, especially for desktop users.

In terms of scalability, Linux 3.0 is designed with many features for
the high-end in mind, but a few in specific are worthy of note for
enterprise computing. Although you might not consider it a performance
feature, the new kernel has reduced the time it takes to boot on
complex hardware by supporting asynchronous scans of storage and other
devices. On servers with many attached drives and shelves, this
results in a significant reduction in downtime between reboots. Linux
3.0 also improves on previous versions' support for hardware
monitoring chipsets for fault recognition, temperature management, and
similar. This grants server administrators more visibility into their
gear and can help prevent crashes.

Security

One of the most notable additions to Linux 2.6 was SELinux, a security
layer provided in part by the NSA that allowed for finer-grained
access controls. This functionality was optional and most Linux
distributions either configure SELinux in more limited ways or
exclusively use the classic UNIX-style permissions system. Linux 3.0
builds on this by bringing in a number of additional security features
which makes it even better suited for critical tasks.

First, in addition to SELinux, three additional security layers have
been provided in Linux 3.0. These layers, still optional, give
administrators a choice as to what type of security is most
appropriate for their environment. The three new layers available in
Linux 3.0 are AppArmor, SMACK (“Simplified Mandatory Access Control
Kernel”) and TOMOYO. The general goal of these approaches are the same
as SELinux: to define a tight set of things that running applications
can do, and prevent them from doing other things. In general, these
other approaches are simpler to configure than SELinux and represent a
compromise between higher security and system maintainability.
Individual features differ and a security administrator should weigh
the benefits of each before implementation.

Another security improvement in Linux 3.0 is the development of
eCryptFS. This module allows for software encryption to be overlaid on
top of any of Linux's existing filesystems on a file-by-file basis,
including network filesystems like NFS. This method is more flexible
than requiring the filesystem to understand encryption itself, and
does not require an encrypted block device. In addition to the new
filesystem, Linux 3.0 also includes the capability to store and manage
encryption keys that are required for this and other encryption
subssytems.

And finally, Linux has made many smaller security improvements, more
than could be listed. Key among these are improved randomization of
memory addressing for processes (to make it much more difficult for an
attacker to overwrite memory with an exploit), implementation of a
non-executable stack to reduce the risk of many kinds of security
holes from poor programming, and a new Secure Computing Mode which
allows the kernel to “sandbox” a process to a restricted set of things
that it can do. This allows for more careful execution of untrusted
code, for example. Linux 3.0 even allows the kernel messages to be
hidden from untrusted users. These changes make Linux an overall
better choice in trusted environments.

Block Devices

Block devices are one of the fundamental device classes on a Linux or
UNIX system. These devices most often represent disk drives or other
storage. When it comes to these devices, Linux has largely reached a
state of maturity but there have been some nice improvements.

Linux has for many years included support for software RAID,
consolidating several drives together to provide redundancy. This is
commonly used in business and enterprise environments for data safety.
In a typical RAID setup, several disks may be strung together such
that the failure of any one of them will not cause data loss. Linux
3.0 now includes the RAID 6 scheme. This scheme uses dual parity
blocks to add a second layer of protection. Users of this scheme will
have to have two simultaneous failures in an array of drives in order
for data to be lost. Linux has further improved data safety by now
also being able to poll the health of compatible underlying devices.
This allows administrators to be aware of potential faults before they
happen.

One other advancement since the launch of Linux 2.6 has been the
beginnings of “object store” devices. Instead of behaving like a disk
where you have a large array of blocks that you can access in any
order, these devices represent a new model where the hardware itself
defines “objects” and “containers” which may be accessed by the
operating system. Linux 3.0 includes support for these Object Storage
Devices (OSDs) as well as a new filesystem, “exofs”, which is designed
to work with them. While this technology has not hit mainstream use
yet, Linux will be ready when and if it does.

Filesystems

Filesystems are one of the most important aspects to a running Linux
system. In short, they are the components that keep track of the
files, directories, symlinks and other components that make up a Linux
system. Most filesystems are tied to a disk, a block device, but some
are over the network only. Linux 3.0 supports many new filesystems
which have been developed to support the many kinds of workloads that
Linux systems can perform.

The first and most important change in Linux 3.0 is the elevation of
the Fourth Extended Filesystem (“ext4”) as the default for most uses.
This major revision to the previous generation (“ext3”) is faster,
less subject to fragmentation, capable of supporting larger volumes,
and recovers better from errors. It's difficult even to list all of
the improvements that ext4 brings, but most of these will be invisible
to the average Linux user. It just works.

A second major advancement in Linux 3.0 is the inclusion of FUSE, or
“Filesystem In Userspace”. This technology allows Linux to be more
flexible in the way that filesystems may be implemented. Now, a
filesystem driver could be written as a real Linux program (instead of
a kernel module) and with FUSE it will be visible just as if it was a
real device. This not only makes filesystem development easier, it has
opened Linux up to a whole continuum of developed mini-filesystems
which would never have been acceptable for inclusion in the kernel.
Linux 3.0 also includes the character-mode equivalent of FUSE: CUSE.
This allows a program to implement a character device (like a keyboard
or printer) in user-space instead of the kernel.

One new filesystem that has been added in Linux 3.0 is “squashfs”.
This is a highly compressed read-only filesystem that is used by some
live CD and rescue disk distributions to cram as much data onto a
filesystem as possible.

On the network side, Linux now supports a new caching add-on for
network filesystems. This allows the OS to create and manage a local
on-disk cache of a remote NFS or CIFS filesystem, decreasing latency
while being fully transparent to the end-user. Linux also now supports
NFSv4, the fourth version of the venerable Network Filesystem as a
client. However, Linux only supports running NFSv3 as a server.

Desktop OS Compatibility

The reality is today that the vast majority of desktop computers out
there are not running Linux. One perpetual area of improvement for the
Linux kernel is compatibility with popular operating systems, to help
users move between them and interoperate with them. While much of this
work lies outside the kernel (for example, connecting to a Microsoft
ActiveDirectory for login credentials), there has been significant
advancement within the Linux 3.0 kernel on this interaction.

While Linux 3.0 still has difficulty accessing NTFS volumes (the
default on modern versions of Windows), support for mounting Windows
network shares has been significantly improved. These shares are
served using the Common Internet Filesystem, or CIFS, which was
developed by Microsoft as a successor to the SMB system used by older
versions of Windows. Linux 3.0 expands on the kernel's CIFS support in
numerous ways such as being able to successfully authenticate against
Kerberos / ActiveDirectory, access to certain CIFS extensions for
better UNIX compatibility, and others. Linux 3.0 also supports the
DFS, Distributed Filesystem, model on top of CIFS. If a network share
moves, Linux will be able to transparently discover the move and
access the new location instead.

On the Apple side, Linux 3.0 is able to mount filesystems created with
the Extended HFS (also known as “HFS+”) filesystem, common on all
Macs. Previous versions of Linux were able to read and write only the
non-extended version of the system.

Laptop Support

Laptops are still a special branch of the PC family. Far more than
desktop computers, laptops have tricky hardware quirks which must be
dealt with by the Linux kernel and special features that aren't found
on full-sized Linux servers. One major area of improvement in Linux
3.0 for laptops is in power management. While previous versions
supported power management, the new kernel does it in a more complete
way. “Standby” mode, where the system powers down to a RAM image is
supported. In addition, Linux has better support for suspending
individual unused devices to conserve power and switching between
multiple graphics processors on systems that have a “high power” and a
“low power” chipset. Laptops also frequently have special keyboard
keys (such as for adjusting volume control or the backlight) and Linux
3.0 is able to control and configure many of these devices.

One feature that makes laptops and portable devices unique is that
they are easy to carry and easy to drop, especially if you have cats
or dogs and like to leave your laptop on the edge of a table. Linux
3.0 includes support for compatible harddisks to “idle immediately”,
that is to stop whatever they are doing and remove the drive heads
from the platters. In conjunction with an internal sensor, this
feature can mean the difference between a nasty look at a pet or loved
one or a nasty look at a pet or loved one followed by a trip to the
computer store.

Graphics Cards

Graphics on Linux has always been a bit of a challenge. Even today,
there are inadequate drivers for most high-end video cards (or the
drivers are not open source and cannot be distributed as a part of
Linux directly) and the separation between what happens in user-space
and what happens in the kernel has been ambiguous at best. Each
iteration of Linux has improved on this somewhat, but there is still
far to go to support hardware in a uniform and feature-complete way.

Linux 3.0 has included a new graphics-brokering subsystem. With
compatible video drivers for the windowing system of choice, Linux is
now able to securely delegate resources on the various devices between
the GUI and the console as well as other applications which are
competing for resources. Linux is also now aware of GPUs and issues
related to GPU memory management and can assist applications and
drivers to use those without contention. For users with a recent
version of the X Window System, Linux 3.0 supports the Direct
Rendering Infrastructure (“DRI”) to allow the use of 3D accelerated
graphics. This functionality is another piece in the Linux video
puzzle.

Not everyone can take advantage of today's whiz-bang graphics. Linux,
the operating system, already supports accessibility options for the
visually impaired. These functions are generally implemented as part
of the distributions and are not necessary to be included in the
kernel. This does lead to a gap between when a Linux system starts
booting and when these accessibility options are activated, and
prevents a visually-impaired person from using the system console. One
improvement in Linux 3.0 is the inclusion of braille console support.
This allows visually impaired Linux users and administrators to access
text-mode Linux even prior to the launching of any other applications.

New Architectures

Although over-shadowed somewhat in recent years as Intel-compatible
processors have dominated the marketplace, a major advantage to Linux
is still its almost ubiquitous compatibility. Linux 3.0 includes
support for several new processor architectures. UniCore, for example,
is a low-power processor designed in China and intended for embedded
devices. Linux also supports (or will support, when the hardware is
generally available) the Tile processors designed by Tilera in Silicon
Valley. They massively multi-core processors have a unique split
between functionality of general-purpose processors and more specific
processing such as would be done on a GPU. Other new supported
processors include the Microblaze, S+core, Blackfin, Atmel, and the
64-bit version of the Super-H.

Although NOT supported by their respective owners, Linux 3.0 includes
some hardware support for Nintendo Wii and Gamecube systems, as well
as the Sony Playstation 3. Actually installing Linux on one of these
devices may be a violation either of your warranty or the law,
depending on your jurisdiction.

In the smart phone space, Linux has become a dominant player thanks to
Google's Android OS, an offshoot of Linux. Although a version of
Android was briefly included in the official Linux kernel
distribution, it has been removed prior to Linux 3.0 due to lack of
maintenance and an increasing divergence between the Linux-maintained
and Google-maintained codebases. It is hoped and anticipated that a
future version of Linux will include these changes.

Networking

Networking has always been one of Linux's strongest features. Even in
the early days when hardware support lagged behind, Linux had a
fantastic network core that made it a go-to operating system for the
Internet set. Linux 3.0 includes many improvements to the network core
including overall better performance and hundreds of new supported
devices.

Perhaps the most noteworthy feature addition in Linux 3.0 is the
inclusion of IPv6. IPv6 is the so-called sixth release of the IP
protocol, the underpinning of the entire Internet and most modern
networking. The current version of the protocol, IPv4, is starting to
show its age and may shortly run out of available network addresses.
While this problem has been addressed in the past through the adoption
of some new technologies (NAT and classless routing, to name two),
it's increasingly clear that a move to IPv6 (or some other technology)
will need to be made at some point. The sixth version of the protocol
supports a significantly lengthened addressing scheme, built in
security features, larger datagram sizes, and other improvements. When
and if we Internet users switch en masse to the new protocol has yet
to be determined, Linux is ready.

Linux 3.0 also includes many other tweaks and improvements to the core
TCP/IP stack. Based on work being done at Google (per a recent
Internet Draft standard document), Linux has updated its TCP
implementation to use a larger initial window size. In order to
prevent congestion on a TCP/IP network, the TCP protocol will “slow
start” to gradually consume more and more bandwidth until either it
runs out of data to send or until it detects congestion. This larger
window size means that the “slow start” starts somewhat less slow. The
end result is that short burst connections will be handled more
efficiently and systems will scale up more quickly to use all
available bandwidth. In addition to this change, Linux's TCP stack now
allows administrators to select from several congestion control
algorithms which each have advantages in certain situations, such as
very high-bandwidth links or wireless devices.

Two other core network features are worthy of note. First, the Linux
network subsystem has been made considerably faster on multi-processor
systems. Unlike under Linux 2.6, incoming network traffic on different
interfaces can now be handled on multiple CPUs. This will ensure that
Linux can deal with multiple high-throughput network devices with less
latency. And second, the Linux wireless driver system has been
completely rewritten. In addition to just supporting many new devices,
these devices are now supported in a more uniform way and with more
features available on more of the cards. Key here are improvements to
the low-level Ethernet implementation (including a complete software
stack where necessary), QoS support, and others.

One increasingly important area of network development is in the wide
use of VPN protocols. VPN, or Virtual Private Network, protocols
connect your personal computer or network to a remote private network
such as at an office. Linux 2.6 already supported several types of
VPNs including those run using IPSec (IP Security) and other forms of
IP-over-IP tunneling. Linux 3.0 builds on this support by adding L2TP,
the Layer 2 Tunneling Protocol. This protocol standard is gaining
traction in the VPN world and is supported on Windows. (L2TP doesn't
actually provide encryption on its own and uses IPSec for that
purpose.) The most common form of Windows VPN connection, PPTP or the
“Point to Point Tunneling Protocol” does have a Linux driver, however
it is still considered experimental in Linux 3.0.

Linux 3.0 includes several other new network stacks which have varying
rates of adoption. BATMAN, or the “Better Approach to Mobile Adhoc
Networking” is new in Linux 3.0 and allows for the creation of a
decentralized network where each node participates in a mesh format.
This could be used in regions where network infrastructure is limited
or monitored. WiMax is also new in Linux 3.0. This technology, with
the correct hardware, allows for joining wide area wireless networks
such as over a rural region where providing wired connectivity is
difficult or impossible.

Device Busses

An unsung hero, device busses are the way that peripherals (both
external and internal) connect with a server or desktop. Linux 3.0
includes expanded support for several old bus types as well as a few
new ones.

One major advancement since the launch of Linux 2.6 has been the
emergence of the PCI Express Bus. PCI Express, sometimes called PCI-E,
is an extension to the “Peripheral Component Interconnect” bus which
has been standard on PCs and many types of servers for nearly twenty
years. PCI Express, in addition to providing faster bus speed for
sending data to and from devices, also supports many modern features
such as hot-plugging. Support for external busses has also
considerably improved since Linux 2.6. USB, the Universal Serial Bus,
has become the standard bus for peripheral devices of all types.
Earlier versions of Linux have included USB support, but Linux 3.0 has
expanded on this by adding support for the latest USB devices (those
that comply with the USB3 specification) as well as many other drivers
and devices. One notable addition is the support for USB video cameras
and webcams which had been lacking in prior versions of Linux.
Firewire, another type of serial bus common in video processing and
other environments, has also be improved in Linux 3.0 with the
addition of a rewritten device stack and many new drivers and fixes.

Although we mainly think of Linux as a platform for hosts to devices,
Linux has become a popular operating system for many types of embedded
hardware. Now stable in Linux 3.0 is “USB On-The-Go”, the device side
of the USB stack. This allows a Linux-running device to connect to and
communicate with a host which speaks the USB protocol. A similar
system, though not used in home computing, is the “Controller Area
Network”. This system is primarily used in automotive and military
computing when multiple devices want to communicate with each other
without the presence of a “host” computer to orchestrate.

Conclusion

I hope you have enjoyed this trip through the new features in Linux
3.0. Please feel free to contact me with any questions and I will do
my best to respond. This document may be redistributed, but I ask that
you please send me an email first so that I can keep track and keep
the link back to the official website where the most recent version
will be stored. If you wish to print any part of this in a magazine,
please let me know. I like copies.

A new Linux kernel release comes only once in a full moon. When you
want to know what's going on between major releases, I have found
these websites to be exceedingly useful. Kudos, guys, for such
outstanding work.

http://kernelnewbies.org/ - The best resource for release-by-release
discussion of the Linux 2.6 development cycle.

http://lwn.net/ - Linux Weekly News with frequent detailed articles on
new Linux kernel features as they emerge.

About the Author

Joe Pranevich has been writing about the Linux kernel since 1998 and
has been a contributor to Linux Magazine, Linux Today, and a number of
other websites and magazines. In his day job, he is the Director of
Technology & Operations for Lycos, Inc. He is also a frequent teaching
fellow and guest lecturer for Harvard University's Extension program's
“Network Protocols and Internet Architecture” class.

Copyright 2011, Joe Pranevich. All trademarked names are owned by
their respective companies.
