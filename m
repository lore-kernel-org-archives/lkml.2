Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878Ab2B2HsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:48:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62508 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab2B2HsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:48:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of david.feuer@gmail.com designates 10.204.155.69 as permitted sender) smtp.mail=david.feuer@gmail.com; dkim=pass header.i=david.feuer@gmail.com
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 02:48:07 -0500
Message-ID: <CAMgWh9tRJ45+X0iuTWXOLeohADi_fbd68e8-cAAroHr2QvyZmQ@mail.gmail.com>
Subject: i915 drm crashes with link to relevant i915_error_state
From: David Feuer <david.feuer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've put up the i915_error_state at
http://techhouse.org/~dfeuer/i915_error_state to (hopefully) allow
this message to go through.

dfeuer@Lemur ~ $ uname -a
Linux Lemur 3.3.0-030300rc5-generic #201202251535 SMP Sat Feb 25
20:36:29 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

The relevant syslog bit:

Feb 29 02:00:07 Lemur kernel: [58897.766802]
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU
hung
Feb 29 02:00:07 Lemur kernel: [58897.766814] [drm] capturing error
event; look for more information in /debug/dri/0/i915_error_state
Feb 29 02:00:07 Lemur udevd[8093]: failed to execute
'/usr/share/apport/apport-gpu-error-intel.py'
'/usr/share/apport/apport-gpu-error-intel.py': No such file or
directory
Feb 29 02:00:07 Lemur kernel: [58897.770984] [drm:i915_wait_request]
*ERROR* i915_wait_request returns -11 (awaiting 3071104 at 3071098,
next 3071105)
Feb 29 02:01:07 Lemur udevd[8097]: failed to execute
'/usr/share/apport/apport-gpu-error-intel.py'
'/usr/share/apport/apport-gpu-error-intel.py': No such file or
directory
Feb 29 02:01:07 Lemur kernel: [58957.629331]
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU
hung
Feb 29 02:01:07 Lemur kernel: [58957.629371] [drm:i915_wait_request]
*ERROR* i915_wait_request returns -11 (awaiting 3105772 at 3105766,
next 3105773)

Note:

I got these two incidents running supertuxkart, which is my favorite
way to generate drm crashes. fgfs (flight sim) and blender (3d
graphics editor) are quite efficient for that too, though much less so
than in previous kernel versions.

David Feuer
