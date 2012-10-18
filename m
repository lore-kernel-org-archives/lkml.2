Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2JRJgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:36:09 -0400
Received: from smtp.getmail.no ([84.208.15.66]:57349 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab2JRJgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:36:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
References: <op.wmbjpvqe6426ze@localhost.localdomain>
Subject: Optimizing scheduling policies for Ubuntu (desktop), for low-jitter.
To: linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 11:36:04 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wmdbmeh66426ze@localhost.localdomain>
In-reply-to: <op.wmbjpvqe6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have made a little script, optimizing Ubuntu abit. If you have any good
and relevant information, reasonable arguments, please post them.

Do note this script is something I have quickly made, and can probably be  
improved. Feedback from experienced desktop-optimizers is appreciated. The  
point is to get waiting due to suboptimal policies out. Making the desktop  
as responsive as it can be.

What it does for the time being, is set X to realtime, so that it`s  
singlethreadedness does not become a performance bottleneck. And all  
daemons to idle pri. Also idle pri, would ofcourse work best, if they are  
queued in a way separately, from normal apps, so they don`t all kick in at  
once. (and cause jitter)

Peace Be With You.

Please CC me.

--

#initctl list | grep running #for running daemons
echo "Setting intelligent scheduling policies."

# realtime priority for that which need it
# RCU boost to 99
sudo schedtool -p 97 -n -20 -F `pgrep X` # X is singlethreaded, this makes  
it perform the best.
#does any other thread benefit(desktop) from realtime?
#for pid in `pgrep "softirqs"`; do
#	sudo schedtool -F -p 98 -n -20 $pid
#done

# idle priority for daemons
for pid in `pgrep "upstart"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
for pid in `pgrep "udev"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
sudo schedtool -p 0 -n 19 -D `pgrep rsyslogd`
for pid in `pgrep "dbus"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
sudo schedtool -p 0 -n 19 -D `pgrep modem-manager`
sudo schedtool -p 0 -n 19 -D `pgrep cupsd`
sudo schedtool -p 0 -n 19 -D `pgrep acpid`
sudo schedtool -p 0 -n 19 -D `pgrep cron`
sudo schedtool -p 0 -n 19 -D `pgrep atd`
for pid in `pgrep "avahi"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
sudo schedtool -p 0 -n 19 -D `pgrep whoopsie`
for pid in `pgrep "winbindd"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
sudo schedtool -p 0 -n 19 -D `pgrep polkit`
sudo schedtool -p 0 -n 19 -D `pgrep timidity`
sudo schedtool -p 0 -n 19 -D `pgrep accounts`
sudo schedtool -p 0 -n 19 -D `pgrep console`
sudo schedtool -p 0 -n 19 -D `pgrep upowerd`
sudo schedtool -p 0 -n 19 -D `pgrep colord`
sudo schedtool -p 0 -n 19 -D `pgrep rtkit` #ubuntu has set this to nice 1?
sudo schedtool -p 0 -n 19 -D `pgrep keyring`
for pid in `pgrep "gvfs"`; do
	sudo schedtool -D -p 0 -n 19 $pid
done
sudo schedtool -p 0 -n 19 -D `pgrep gconf`

# remomve unneeded
#sudo stop tty6
#sudo stop tty5
#sudo stop tty4
#sudo stop tty3
#sudo stop tty2
#sudo stop tty1
#sudo modprobe -r usb-storage
sudo modprobe -r snd_seq_dummy # is anyone using this?
sudo modprobe -r snd_seq_oss
sudo modprobe -r snd_seq_midi
sudo modprobe -r snd_rawmidi
sudo modprobe -r snd_seq_midi_event
#sudo modprobe -r snd_seq
sudo modprobe -r snd_pcm_oss
sudo modprobe -r snd_mixer_oss
sudo modprobe -r serio_raw
