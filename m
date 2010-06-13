Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0FMIXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:23:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55255 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0FMIXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ng6ScidzoDkrHcZbEhcJnShvq99A7+t/DO5GKt7zxsJxF+ZEL05cOpV4Rdr5cSVXtA
         vJYXz/cPdzGZxugULU0QC/3jNsPtDlbU5nzdrKjoyctljzIuq56mcxhNSZD3IUHS2UlM
         p9o8+gFHnxmTjtnXABNZTFn92EkIZpUXGaQMg=
MIME-Version: 1.0
In-Reply-To: <E1OMQ88-0002a1-Gb@closure.thunk.org>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
Date: Sun, 13 Jun 2010 18:23:45 +1000
Message-ID: <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 4:36 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> My laptop is running 2.6.35-rc2 (plus a few patches) and after not quite
> four hours of beeing booted (3:45 to be precise), top shows that kslowd
> has accumulated as surprising amount of CPU time.  From top display:
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  6173 root      15  -5     0    0    0 S    6  0.0  10:42.91 kslowd001
>  1219 root      15  -5     0    0    0 S    5  0.0  11:00.68 kslowd000
>  1765 root      15  -5     0    0    0 S    5  0.0  10:59.20 kslowd002
>  6784 root      15  -5     0    0    0 S    4  0.0  10:34.37 kslowd003
>  4946 root      20   0  144m  34m  17m S    3  0.9   2:24.62 Xorg
>
> This came up because I was trying to figure out why mouse response was
> being so jerky.  There aren't that many users of slow-work, and given
> that I'm not using cifs, fscache, gfs2, my suspicions are falling on
> drivers/gpu/drm/drm_crtc_helper.c (Would this be something that would be
> in use on a Lenovo T400 laptop?)
>
> Is there any way to easily see what is scheduling themselves to use the
> slow workqueue?

Its an output polling feature of KMS, however it shouldn't cause
disruption elsewhere, but we are holding a mutex in there that there
isn't a real need to hold, so I suspect I'll drop that.

What GPU is it?

Dave.
