Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0CRHEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 03:04:49 -0400
Received: from psi.thgersdorf.net ([188.40.92.130]:53905 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0CRHEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:04:48 -0400
Date: Thu, 18 Mar 2010 08:04:43 +0100
From: Dieter Ries <mail@dieterries.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Message-ID: <20100318070443.GB24062@Localhorst.asterix.local>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
 <1258373983-8693-24-git-send-email-avi@redhat.com>
 <4BA1504A.3090801@dieterries.net>
 <808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
 <20100317224002.GA5156@Localhorst.asterix.local>
 <4BA1BD08.4020401@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1BD08.4020401@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 08:41:28AM +0300, Michael Tokarev wrote:
> Dieter Ries wrote:
> > On Wed, Mar 17, 2010 at 11:02:40PM +0100, Alexander Graf wrote:
> []
> >> Are you 100% sure you don't have vmware, virtualbox, parallels, whatever running in parallel on that machine?
> > 
> > Definitely. I have virtualbox installed, but haven't used it in months.
> > The others I don't use at all, so they are not installed either.
> 
> Dieter, we've talked with you on IRC yesterday...

Yes, I remember.

> Can you take a look at what's in the startup script sequence on
> your machine, and what modules are loaded which may be related?
> What I'm trying to say: I don't know how virtualbox works, but it
> may come with a kernel module or a bootup script that touches SVM
> settings.

I checked it again: I don't even have the virtualbox modules installed
for this kernel, I cannot modprobe them.

lsmod is here:
before modprobe kvm_amd
Module                  Size  Used by
snd_pcm_oss            33062  0 
snd_mixer_oss          13798  1 snd_pcm_oss
snd_seq_oss            23963  0 
snd_seq_midi_event      5684  1 snd_seq_oss
snd_seq                44953  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          5481  2 snd_seq_oss,snd_seq
nvidia               9613596  40 
snd_hda_codec_realtek   264327  1 
snd_hda_intel          20099  4 
snd_hda_codec          57443  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               5642  1 snd_hda_codec
snd_pcm                68342  4 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              17426  3 snd_seq,snd_pcm
snd                    52486  17
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               6287  1 snd
snd_page_alloc          7029  2 snd_hda_intel,snd_pcm
i2c_core               18944  1 nvidia

after:
Module                  Size  Used by
kvm_amd                32387  0 
kvm                   249238  1 kvm_amd
snd_pcm_oss            33062  0 
snd_mixer_oss          13798  1 snd_pcm_oss
snd_seq_oss            23963  0 
snd_seq_midi_event      5684  1 snd_seq_oss
snd_seq                44953  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          5481  2 snd_seq_oss,snd_seq
nvidia               9613596  40 
snd_hda_codec_realtek   264327  1 
snd_hda_intel          20099  4 
snd_hda_codec          57443  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               5642  1 snd_hda_codec
snd_pcm                68342  4 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              17426  3 snd_seq,snd_pcm
snd                    52486  17
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               6287  1 snd
snd_page_alloc          7029  2 snd_hda_intel,snd_pcm
i2c_core               18944  1 nvidia


This is a gentoo box, and there are no services started which are
related to virtualization. No autoloaded modules or anything. Just
standard desktop stuff + lvm and raid.

Runlevel: boot
 hwclock                                                                      [  started  ]
 modules                                                                      [  started  ]
 lvm                                                                          [  started  ]
 device-mapper                                                                [  started  ]
 fsck                                                                         [  started  ]
 root                                                                         [  started  ]
 mtab                                                                         [  started  ]
 hostname                                                                     [  started  ]
 localmount                                                                   [  started  ]
 sysctl                                                                       [  started  ]
 bootmisc                                                                     [  started  ]
 sysklogd                                                                     [  started  ]
 urandom                                                                      [  started  ]
 termencoding                                                                 [  started  ]
 consolefont                                                                  [  started  ]
 net.lo                                                                       [  started  ]
 staticroute                                                                  [  started  ]
 mdadm                                                                        [  started  ]
 swap                                                                         [  started  ]
 acpid                                                                        [  started  ]
 procfs                                                                       [  started  ]
 keymaps                                                                      [  started  ]

modules is empty.

And additionally after boot:

Runlevel: default
 sysklogd                                                                     [  started  ]
 dbus                                                                         [  started  ]
 hald                                                                         [  started  ]
 xdm                                                                          [  started  ]
 preload                                                                      [  started  ]
 udev-postmount                                                               [  started  ]
 ntpd                                                                         [  started  ]
 alsasound                                                                    [  started  ]
 avahi-daemon                                                                 [  started  ]
 cupsd                                                                        [  started  ]
 sshd                                                                         [  started  ]
 local                                                                        [  started  ]
Dynamic Runlevel: hotplugged
 net.eth1                                                                     [  started  ]
Dynamic Runlevel: needed
 udev-mount                                                                   [  started  ]
 sysfs                                                                        [  started  ]

> /mjt

cu
Dieter

