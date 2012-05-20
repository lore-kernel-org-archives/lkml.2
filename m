Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2ETR7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 13:59:12 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:51028 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab2ETR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 13:59:09 -0400
X-Greylist: delayed 1028 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 13:59:09 EDT
Date: Sun, 20 May 2012 14:38:12 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: cpufreq not working properly with ondemand governor on Intel(R)
 Core(TM) i5-2467M
Message-ID: <20120520173812.GU4370@llucax.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just bought a Toshiba Z830 and I'm having a problem with cpufreq. The
default governor is ondemand and it's not working properly, the
frequency is stuck at the lowest one, which makes the notebook really
annoying to use. I've tried the performance governor and it looks like
the CPU goes to the maximum frequency, but when querying with cpufreq-
info, I still see the minimum freq, but in the statistics about the
frequencies used, I see the maximum frequency getting more and more
percentage of use.

Finally I tried the conservative governor, and it really look like it
behaves like the ondeman should. The frequency is rapidily increased as
needed and dropped down again when is not needed anymore. This is the
only governor that seems to be changing the frequency in a way cpufreq-
info can really see it, as I see the frequency going up and down when
using that governor. The userspace governor also seems to be working as
expected though.

Another strange thing is that among the supported frequencies, I get
1.60GHz (the maximum frequency supported) listed twice.

Here is an example run of cpufreq-info:
cpufrequtils 007: cpufreq-info (C) Dominik Brodowski 2004-2009
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 1.60 GHz:6.40%, 1.60 GHz:0.01%, 1.50 GHz:0.02%, 1.40 GHz:0.02%, 1.30 GHz:0.02%, 1.20 GHz:0.06%, 1.10 GHz:0.03%, 1000 MHz:0.04%, 900 MHz:0.07%, 800 MHz:93.33%  (795)
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 1
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 1.60 GHz:20.97%, 1.60 GHz:0.02%, 1.50 GHz:0.06%, 1.40 GHz:0.07%, 1.30 GHz:0.10%, 1.20 GHz:0.18%, 1.10 GHz:0.10%, 1000 MHz:0.15%, 900 MHz:0.19%, 800 MHz:78.16%  (424)
analyzing CPU 2:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 2
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 1.60 GHz:20.95%, 1.60 GHz:0.02%, 1.50 GHz:0.11%, 1.40 GHz:0.10%, 1.30 GHz:0.12%, 1.20 GHz:0.32%, 1.10 GHz:0.24%, 1000 MHz:0.25%, 900 MHz:0.38%, 800 MHz:77.51%  (622)
analyzing CPU 3:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 3
  maximum transition latency: 10.0 us.
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 1.60 GHz, 1.50 GHz, 1.40 GHz, 1.30 GHz, 1.20 GHz, 1.10 GHz, 1000 MHz, 900 MHz, 800 MHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz.
  cpufreq stats: 1.60 GHz:20.89%, 1.60 GHz:0.03%, 1.50 GHz:0.09%, 1.40 GHz:0.11%, 1.30 GHz:0.11%, 1.20 GHz:0.19%, 1.10 GHz:0.15%, 1000 MHz:0.13%, 900 MHz:0.14%, 800 MHz:78.15%  (451)

I first reported this issue to Ubuntu but it seems to be a general
kernel problem. You can find all the details (kernel version, CPU model,
etc.) in that bug report. Let me know if you need any other information.
https://bugs.launchpad.net/bugs/987531


Thanks.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
Hey you, with you ear against the wall
Waiting for someone to call out
Would you touch me?
