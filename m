Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab1GOBdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 21:33:31 -0400
Received: from iabervon.org ([66.92.72.58]:33854 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1GOBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 21:33:30 -0400
Date: Thu, 14 Jul 2011 21:26:11 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
In-Reply-To: <alpine.LNX.2.00.1107141330370.2056@iabervon.org>
Message-ID: <alpine.LNX.2.00.1107142116260.2056@iabervon.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org> <20110714135302.GA28501@thinkpad-t410> <alpine.LNX.2.00.1107141330370.2056@iabervon.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1547844168-1424794335-1310693171=:2056"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1547844168-1424794335-1310693171=:2056
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 14 Jul 2011, Daniel Barkalow wrote:

> On Thu, 14 Jul 2011, Seth Forshee wrote:
> 
> > On Wed, Jul 13, 2011 at 10:10:13PM -0400, Daniel Barkalow wrote:
> > > I've got an ipod which doesn't work with 2.6.38 or later, unless I revert:
> > > 
> > > 358f26d52680cb150907302d4334359de7dd2d59
> > > 52399b171dfaea02b6944cd6feba49b624147126
> > > 
> > > In the failing case, I get:
> > > 
> > >  sd 2:0:0:0: [sdb] Bad block number requested
> > >  hfs: unable to find HFS+ superblock
> > > 
> > > in dmesg when I try to mount it.
> > > 
> > > Before 2.6.38, or with those commits reverted, it mounts fine and works so 
> > > far as I can tell. (There's an Ubuntu bug report: 
> > > https://bugs.launchpad.net/ubuntu/+source/util-linux/+bug/734883, which 
> > > reports other people having similar results). I can test patches and 
> > > collect information that might be helpful, if you have any ideas.
> > 
> > This has had some discussion on lkml previously [1]. I've been trying to
> > work on a fix, but the current iteration has problems, and I haven't
> > been able to get testers to provide the logs I've requested to help me
> > see what's going wrong. If you'd like to help by providing logs from the
> > most recent test build on the bug you linked to (or using the patches
> > from that build) that would be great. I unfortunately don't have any
> > large-sector devices to test with and cannot reproduce the problems on
> > 512-byte sector devices.
> 
> Sure, I'll try the comment #36 patch set this evening and see what it says.

Okay, I've applied that patch set, and it worked for me without any issues 
thus far. If you're interested in the debugging output from a device that 
doesn't work with vanilla but doesn't oops or panic with that patch set, 
it's attached. I'm using 32-bit x86, if that helps for tracking down 
differences.

	-Daniel
*This .sig left intentionally blank*
--1547844168-1424794335-1310693171=:2056
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=hfsplus-debug
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1107142126110.2056@iabervon.org>
Content-Description: 
Content-Disposition: attachment; filename=hfsplus-debug

dXNiIDEtMzogbmV3IGhpZ2ggc3BlZWQgVVNCIGRldmljZSB1c2luZyBlaGNp
X2hjZCBhbmQgYWRkcmVzcyAzDQpzY3NpMiA6IHVzYi1zdG9yYWdlIDEtMzox
LjANCnNjc2kgMjowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAgQXBwbGUgICAg
aVBvZCAgICAgICAgICAgICAxLjYyIFBROiAwIEFOU0k6IDANCnNkIDI6MDow
OjA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzIgdHlwZSAwDQpzZCAyOjA6
MDowOiBbc2RiXSAzOTY0OTI4IDIwNDgtYnl0ZSBsb2dpY2FsIGJsb2Nrczog
KDguMTIgR0IvNy41NiBHaUIpDQpzZCAyOjA6MDowOiBbc2RiXSBXcml0ZSBQ
cm90ZWN0IGlzIG9mZg0Kc2QgMjowOjA6MDogW3NkYl0gTW9kZSBTZW5zZTog
NjggMDAgMDAgMDgNCnNkIDI6MDowOjA6IFtzZGJdIEFzc3VtaW5nIGRyaXZl
IGNhY2hlOiB3cml0ZSB0aHJvdWdoDQpzZCAyOjA6MDowOiBbc2RiXSAzOTY0
OTI4IDIwNDgtYnl0ZSBsb2dpY2FsIGJsb2NrczogKDguMTIgR0IvNy41NiBH
aUIpDQpzZCAyOjA6MDowOiBbc2RiXSBBc3N1bWluZyBkcml2ZSBjYWNoZTog
d3JpdGUgdGhyb3VnaA0KIHNkYjogW21hY10gc2RiMSBzZGIyIHNkYjMNCnNk
IDI6MDowOjA6IFtzZGJdIDM5NjQ5MjggMjA0OC1ieXRlIGxvZ2ljYWwgYmxv
Y2tzOiAoOC4xMiBHQi83LjU2IEdpQikNCnNkIDI6MDowOjA6IFtzZGJdIEFz
c3VtaW5nIGRyaXZlIGNhY2hlOiB3cml0ZSB0aHJvdWdoDQpzZCAyOjA6MDow
OiBbc2RiXSBBdHRhY2hlZCBTQ1NJIHJlbW92YWJsZSBkaXNrDQpTQUY6IGhm
c3BsdXNfc3VibWl0X2Jpbzogc2VjdG9yIDIgYnVmICAgKG51bGwpIHJ3IC0x
ODMwNzQ4MTYNClNBRjogaGZzcGx1c19zdWJtaXRfYmlvOiBpb19zaXplIDIw
NDggc3RhcnQgMTAyNCBvZmZzZXQgMTAyNCBzZWN0b3IgMA0KU0FGOiBoZnNw
bHVzX3N1Ym1pdF9iaW86IGRhdGEgZjUwNmQ1NDQNClNBRjogaGZzcGx1c19z
dWJtaXRfYmlvOiBpb19zaXplIDIwNDggcGFnZV9vZmZzZXQgMCBsZW4gMjA0
OCBidWYgZjUxNjgwMDANClNBRjogaGZzcGx1c19zdWJtaXRfYmlvOiBzZWN0
b3IgMTU2MTUxNzggYnVmICAgKG51bGwpIHJ3IC0xODA2NjQzMjANClNBRjog
aGZzcGx1c19zdWJtaXRfYmlvOiBpb19zaXplIDIwNDggc3RhcnQgNzk5NDk3
MTEzNiBvZmZzZXQgMTAyNCBzZWN0b3IgMTU2MTUxNzYNClNBRjogaGZzcGx1
c19zdWJtaXRfYmlvOiBkYXRhIGY1MDZkNTRjDQpTQUY6IGhmc3BsdXNfc3Vi
bWl0X2JpbzogaW9fc2l6ZSAyMDQ4IHBhZ2Vfb2Zmc2V0IDIwNDggbGVuIDIw
NDggYnVmIGY1M2I0ODAwDQpoZnM6IHdyaXRlIGFjY2VzcyB0byBhIGpvdXJu
YWxlZCBmaWxlc3lzdGVtIGlzIG5vdCBzdXBwb3J0ZWQsIHVzZSB0aGUgZm9y
Y2Ugb3B0aW9uIGF0IHlvdXIgb3duIHJpc2ssIG1vdW50aW5nIHJlYWQtb25s
eS4NClNBRjogaGZzcGx1c19zdWJtaXRfYmlvOiBzZWN0b3IgMiBidWYgICAo
bnVsbCkgcncgLTE5NjIzNzMxMg0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86
IGlvX3NpemUgMjA0OCBzdGFydCAxMDI0IG9mZnNldCAxMDI0IHNlY3RvciAw
DQpTQUY6IGhmc3BsdXNfc3VibWl0X2JpbzogZGF0YSBmNTA2ZDU0NA0KU0FG
OiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlvX3NpemUgMjA0OCBwYWdlX29mZnNl
dCAyMDQ4IGxlbiAyMDQ4IGJ1ZiBmNDRkYTgwMA0KU0FGOiBoZnNwbHVzX3N1
Ym1pdF9iaW86IHNlY3RvciAxNTYxNTE3OCBidWYgICAobnVsbCkgcncgLTE3
MzcyMTYwMA0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlvX3NpemUgMjA0
OCBzdGFydCA3OTk0OTcxMTM2IG9mZnNldCAxMDI0IHNlY3RvciAxNTYxNTE3
Ng0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGRhdGEgZjUwNmQ1NGMNClNB
RjogaGZzcGx1c19zdWJtaXRfYmlvOiBpb19zaXplIDIwNDggcGFnZV9vZmZz
ZXQgMjA0OCBsZW4gMjA0OCBidWYgZjVhNTM4MDANClNBRjogaGZzcGx1c19z
dWJtaXRfYmlvOiBzZWN0b3IgMiBidWYgICAobnVsbCkgcncgLTE5NjIzNzMx
Mg0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlvX3NpemUgMjA0OCBzdGFy
dCAxMDI0IG9mZnNldCAxMDI0IHNlY3RvciAwDQpTQUY6IGhmc3BsdXNfc3Vi
bWl0X2JpbzogaW9fc2l6ZSAyMDQ4IHBhZ2Vfb2Zmc2V0IDIwNDggbGVuIDIw
NDggYnVmIGY0NGRhODAwDQpTQUY6IGhmc3BsdXNfc3VibWl0X2Jpbzogc2Vj
dG9yIDIgYnVmICAgKG51bGwpIHJ3IC0xOTYyMzczMTINClNBRjogaGZzcGx1
c19zdWJtaXRfYmlvOiBpb19zaXplIDIwNDggc3RhcnQgMTAyNCBvZmZzZXQg
MTAyNCBzZWN0b3IgMA0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlvX3Np
emUgMjA0OCBwYWdlX29mZnNldCAyMDQ4IGxlbiAyMDQ4IGJ1ZiBmNDRkYTgw
MA0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IHNlY3RvciAyIGJ1ZiAgIChu
dWxsKSBydyAtMTk2MjM3MzEyDQpTQUY6IGhmc3BsdXNfc3VibWl0X2Jpbzog
aW9fc2l6ZSAyMDQ4IHN0YXJ0IDEwMjQgb2Zmc2V0IDEwMjQgc2VjdG9yIDAN
ClNBRjogaGZzcGx1c19zdWJtaXRfYmlvOiBpb19zaXplIDIwNDggcGFnZV9v
ZmZzZXQgMjA0OCBsZW4gMjA0OCBidWYgZjQ0ZGE4MDANClNBRjogaGZzcGx1
c19zdWJtaXRfYmlvOiBzZWN0b3IgMiBidWYgICAobnVsbCkgcncgLTE5NjIz
NzMxMg0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlvX3NpemUgMjA0OCBz
dGFydCAxMDI0IG9mZnNldCAxMDI0IHNlY3RvciAwDQpTQUY6IGhmc3BsdXNf
c3VibWl0X2JpbzogaW9fc2l6ZSAyMDQ4IHBhZ2Vfb2Zmc2V0IDIwNDggbGVu
IDIwNDggYnVmIGY0NGRhODAwDQpTQUY6IGhmc3BsdXNfc3VibWl0X2Jpbzog
c2VjdG9yIDIgYnVmICAgKG51bGwpIHJ3IC0xOTYyMzczMTINClNBRjogaGZz
cGx1c19zdWJtaXRfYmlvOiBpb19zaXplIDIwNDggc3RhcnQgMTAyNCBvZmZz
ZXQgMTAyNCBzZWN0b3IgMA0KU0FGOiBoZnNwbHVzX3N1Ym1pdF9iaW86IGlv
X3NpemUgMjA0OCBwYWdlX29mZnNldCAyMDQ4IGxlbiAyMDQ4IGJ1ZiBmNDRk
YTgwMA0K

--1547844168-1424794335-1310693171=:2056--
