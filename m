Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab2FFXBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:01:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50067 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2FFXBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:01:23 -0400
MIME-Version: 1.0
X-Originating-IP: [197.179.0.64]
In-Reply-To: <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
 <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Thu, 7 Jun 2012 02:01:01 +0300
Message-ID: <CAHVUoiQgcAMr874d_yPfm9ssUBOoX+dNLy9JNCOCYwOCrAKXFQ@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: multipart/mixed; boundary=20cf3074d5a2e610f204c1d5be3b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3074d5a2e610f204c1d5be3b
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 7, 2012 at 1:59 AM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> On Sun, Jun 3, 2012 at 8:26 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
>> Hello,
>>
>> 3.4 breaks rendering on my Radeon evergreen card. Immediately after
>> logging in into the desktop, I get the following errors in the kernel
>> log:
>>
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
>> 575)
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>> surf: (192 192) (0 4 1 0 0 0 0)
>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
>> 575)
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>> surf: (192 192) (0 4 1 0 0 0 0)
>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>> small (layer size 798720, offset 0, max layer 1, bo size 794624, slice
>> 3119)
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>> surf: (384 520) (0 4 1 0 0 0 0)
>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>> small (layer size 458752, offset 0, max layer 1, bo size 446464, slice
>> 1791)
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>> surf: (512 224) (0 4 1 0 0 0 0)
>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 7170
>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
>> small (layer size 798720, offset 0, max layer 1, bo size 790528, slice
>> 3119)
>> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
>> surf: (384 520) (0 4 1 0 0 0 0)
>> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
>> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>>
>> Meanwhile, windows on the desktop are rendered incorrectly (with
>> certain regions covered by strange patterns or smudged) or not at all.
>> This makes the desktop unusable.
>>
>> I can always reproduce this problem on 3.4
>>
>> Kernels prior to 3.4 work fine.
>>
>> I will try and find the time to bisect this issue but meanwhile here
>> are some further details:
>>
>
> I have git-bisected this to find that the first bad commit is:
> 285484e2d55 - drm/radeon: add support for evergreen/ni tiling
> informations v11.
>
> So I have also added Jerome to the CC list. Please see the attached
> bisect.log for the git-bisect log.

Sorry, forgot to attach. Now attached.

-- 
Brian Gitonga Marete
Toshnix Systems - http://toshnix.com

--20cf3074d5a2e610f204c1d5be3b
Content-Type: application/octet-stream; name="bisect.log"
Content-Disposition: attachment; filename="bisect.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3503wvi0

Z2l0IGJpc2VjdCBzdGFydCAnZHJpdmVycy9ncHUnCiMgYmFkOiBbNzZlMTBkMTU4ZWZiNmQ0NTE2
MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiY10gTGludXggMy40CmdpdCBiaXNlY3QgYmFkIDc2ZTEwZDE1
OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmMKIyBnb29kOiBbYzE2ZmE0ZjJhZDE5OTA4
YTQ3YzYzZDhmYTQzNmExMTc4NDM4YzdlN10gTGludXggMy4zCmdpdCBiaXNlY3QgZ29vZCBjMTZm
YTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTExNzg0MzhjN2U3CiMgYmFkOiBbNTBkNDRhNTIzNzU5
YzM5YWYxMTE5Mjg1YTUzOTZjYTM4NzI4OGFmMF0gZ21hNTAwOiBGaXggcmVzdW1lIHBhdGhzCmdp
dCBiaXNlY3QgYmFkIDUwZDQ0YTUyMzc1OWMzOWFmMTExOTI4NWE1Mzk2Y2EzODcyODhhZjAKIyBi
YWQ6IFszYWUxOWI3NTBiZGMwOWNlMjMzZTE1MDQzNDgzMjAxNDE1OTNmZmRhXSBkcm0vcmFkZW9u
L2ttczogYWRkIHdhaXRfZm9yX3ZibGFuayBhc2ljIGNhbGxiYWNrCmdpdCBiaXNlY3QgYmFkIDNh
ZTE5Yjc1MGJkYzA5Y2UyMzNlMTUwNDM0ODMyMDE0MTU5M2ZmZGEKIyBnb29kOiBbMDUyOWEwZDlm
MGU3MDJmZDUyMTVhNDkzYjc0NDBiZTczZjU5NDFhZl0gZHJtL2k5MTU6IGNvcnJlY3RseSBwcm9n
cmFtIHRoZSBWU1lOQ1NISUZUIHJlZ2lzdGVyCmdpdCBiaXNlY3QgZ29vZCAwNTI5YTBkOWYwZTcw
MmZkNTIxNWE0OTNiNzQ0MGJlNzNmNTk0MWFmCiMgZ29vZDogW2ViNGY5MjNiMWNlYWM4YTYxODQ2
OWM1MWZmMjQ5YmQ4OWJjMGRmYTRdIHZtd2dmeDogUGljayB1cCB0aGUgaW5pdGlhbCBzaXplIGZy
b20gdGhlIHdpZHRoIGFuZCBoZWlnaHQgcmVncwpnaXQgYmlzZWN0IGdvb2QgZWI0ZjkyM2IxY2Vh
YzhhNjE4NDY5YzUxZmYyNDliZDg5YmMwZGZhNAojIGdvb2Q6IFthNzFkOGQ5NDUyNWU4ZmQ4NTVj
MDQ2NmZiNTg2YWUxY2IwMDhmM2EyXSBkcm0vaTkxNTogUmVjb3JkIHRoZSB0YWlsIGF0IGVhY2gg
cmVxdWVzdCBhbmQgdXNlIGl0IHRvIGVzdGltYXRlIHRoZSBoZWFkCmdpdCBiaXNlY3QgZ29vZCBh
NzFkOGQ5NDUyNWU4ZmQ4NTVjMDQ2NmZiNTg2YWUxY2IwMDhmM2EyCiMgYmFkOiBbNDJiOTIzYjU4
N2QwNTVjZDk4ZmI4NGYzMmUzZTc1ODY3MjAyNmFlOV0gZHJtL3JhZGVvbi9ldmVyZ3JlZW46IG1h
a2UgdGV4ZHdbXSBhcnJheSBsYXJnZXIKZ2l0IGJpc2VjdCBiYWQgNDJiOTIzYjU4N2QwNTVjZDk4
ZmI4NGYzMmUzZTc1ODY3MjAyNmFlOQojIGdvb2Q6IFs1MWE1OWFjODczOWIzMzNlYWE0M2EzMTAy
YjZhY2FhYjUwMzdiZmEyXSBkcm06IEZpeCBrY2FsbG9jIHBhcmFtZXRlcnMgc3dhcHBlZApnaXQg
YmlzZWN0IGdvb2QgNTFhNTlhYzg3MzliMzMzZWFhNDNhMzEwMmI2YWNhYWI1MDM3YmZhMgojIGJh
ZDogWzI4NTQ4NGUyZDU1ZTc2MDMxYjQ1OTI2NzIwYzEwYjFhZWM4Yjc4MmFdIGRybS9yYWRlb246
IGFkZCBzdXBwb3J0IGZvciBldmVyZ3JlZW4vbmkgdGlsaW5nIGluZm9ybWF0aW9ucyB2MTEKZ2l0
IGJpc2VjdCBiYWQgMjg1NDg0ZTJkNTVlNzYwMzFiNDU5MjY3MjBjMTBiMWFlYzhiNzgyYQojIGdv
b2Q6IFtkZDIyMGEwMGU4YmQ1YWQ3Zjk4ZWNkYzNlZWQ2OTlhN2NmYWJkYzI3XSBkcm0vcmFkZW9u
L2ttczogYWRkIHN1cHBvcnQgZm9yIHN0cmVhbW91dCB2NwpnaXQgYmlzZWN0IGdvb2QgZGQyMjBh
MDBlOGJkNWFkN2Y5OGVjZGMzZWVkNjk5YTdjZmFiZGMyNwo=
--20cf3074d5a2e610f204c1d5be3b--
