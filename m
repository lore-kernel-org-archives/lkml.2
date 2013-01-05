Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3AEJbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:31:19 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39136 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3AEJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:31:13 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 5 Jan 2013 10:31:11 +0100
Message-ID: <CA+icZUUMTfbAj81NVkP9dJjacp+SYAN+=Fo1EM6+5sjfgTo42g@mail.gmail.com>
Subject: Re: [PATCH 0/6] ACPI / PM: ACPI power management update
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

against which Linux-kernel version is your patchset?
Linux v3.8-rc2?
Mambo number 5 [1] aka patch 5/6 does not apply cleanly.

Regards,
- Sedat -

[1] http://www.youtube.com/watch?v=QQ4Ht5xfD5E

P.S.: GIT AM and APPLY sessions

GIT AM...

wearefam@fambox:~/src/linux-kernel/linux$ git checkout Linux-v3.8-rc2
Already on 'Linux-v3.8-rc2'
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ GIT_BRANCH="acpi-pm-fixes" ;
git branch $GIT_BRANCH && git checkout $GIT_BRANCH
Switched to branch 'acpi-pm-fixes'
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ git am
../patches/acpi-pm-fixes/1-6-ACPI-PM-Change-the-way-power-transitions-to-D3cold-are-carried-out.patch
Applying: ACPI / PM: Change the way power transitions to D3cold are carried out
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ git am
../patches/acpi-pm-fixes/2-6-ACPI-PM-More-visible-function-for-retrieving-device-power-states.patch
Applying: ACPI / PM: More visible function for retrieving device power states
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ git am
../patches/acpi-pm-fixes/3-6-ACPI-PM-Common-string-representations-of-device-power-states.patch
Applying: ACPI / PM: Common string representations of device power states
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ git am
../patches/acpi-pm-fixes/4-6-ACPI-PM-Export-power-states-of-ACPI-devices-via-sysfs.patch
Applying: ACPI / PM: Export power states of ACPI devices via sysfs
wearefam@fambox:~/src/linux-kernel/linux$
wearefam@fambox:~/src/linux-kernel/linux$ git am
../patches/acpi-pm-fixes/5-6-ACPI-PM-Move-device-power-management-functions-to-device_pm.c.patch
Applying: ACPI / PM: Move device power management functions to device_pm.c
error: patch failed: include/acpi/acpi_bus.h:333
error: include/acpi/acpi_bus.h: patch does not apply
Patch failed at 0001 ACPI / PM: Move device power management functions
to device_pm.c
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

Same with GIT APPLY...

[...]
wearefam@fambox:~/src/linux-kernel/linux$ git apply --check --verbose
../patches/acpi-pm-fixes/5*
Checking patch drivers/acpi/device_pm.c...
Checking patch include/acpi/acpi_bus.h...
error: while searching for:
acpi_status acpi_bus_get_status_handle(acpi_handle handle,
                                       unsigned long long *sta);
int acpi_bus_get_status(struct acpi_device *device);
int acpi_bus_set_power(acpi_handle handle, int state);
const char *acpi_power_state_string(int state);
int acpi_device_get_power(struct acpi_device *device, int *state);
int acpi_device_set_power(struct acpi_device *device, int state);
int acpi_bus_update_power(acpi_handle handle, int *state_p);
bool acpi_bus_power_manageable(acpi_handle handle);
bool acpi_bus_can_wakeup(acpi_handle handle);
#ifdef CONFIG_ACPI_PROC_EVENT
int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
int acpi_bus_generate_proc_event4(const char *class, const char *bid,
u8 type, int data);

error: patch failed: include/acpi/acpi_bus.h:333
error: include/acpi/acpi_bus.h: patch does not apply
Checking patch drivers/acpi/internal.h...
Hunk #1 succeeded at 43 (offset -18 lines).
Checking patch drivers/acpi/bus.c...
- EOT-
