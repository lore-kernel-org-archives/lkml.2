Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1JPNsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 09:48:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:40771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1JPNse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 09:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="63391023"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20staging=3A=20mei=3A=20updating=20mei=20driver=20documentation?=
Date: Sun, 16 Oct 2011 15:45:20 +0200
Message-Id: <1318772721-3243-2-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318772721-3243-1-git-send-email-oren.jer.weil@intel.com>
References: <1318772721-3243-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update links to working links
remove old information about module parameters
add IOCTL information.
cleanups
fix spelling

Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/mei.txt |  222 ++++++++++++++++++++++++-------------------
 1 files changed, 124 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/mei/mei.txt b/drivers/staging/mei/mei.txt
index 17302ad..9e49aef 100644
--- a/drivers/staging/mei/mei.txt
+++ b/drivers/staging/mei/mei.txt
@@ -1,78 +1,74 @@
-Intel MEI
+Intel(R) Management Engine Interface (Intel(R) MEI)
 =======================
 
 Introduction
 =======================
 
-The Intel Management Engine (Intel ME) is an isolated and
-protected computing resource (Coprocessor) residing inside
-Intel chipsets. The Intel ME provides support for computer/IT
-management features.
-The Feature set depends on the Intel chipset SKU.
+The Intel Management Engine (Intel ME) is an isolated andprotected computing
+resource (Co-processor) residing inside certain Intel chipsets. The Intel ME
+provides support for computer/IT management features. The feature set
+depends on the Intel chipset SKU.
 
-The Intel Management Engine Interface (Intel MEI, previously known
-as HECI) is the interface between the Host and Intel ME.
-This interface is exposed to the host as a PCI device.
-The Intel MEI Driver is in charge of the communication channel
-between a host application and the ME feature.
+The Intel Management Engine Interface (Intel MEI, previously known as HECI)
+is the interface between the Host and Intel ME. This interface is exposed
+to the host as a PCI device. The Intel MEI Driver is in charge of the
+communication channel between a host application and the Intel ME feature.
 
-Each Intel ME feature (Intel ME Client) is addressed by
-GUID/UUID and each feature defines its own protocol.
-The protocol is message-based with a header and payload up to
-512 bytes.
+Each Intel ME feature (Intel ME Client) is addressed by a GUID/UUID and
+each client has its own protocol. The protocol is message-based with a
+header and payload up to 512 bytes.
 
-[place holder to URL to protocol definitions]
-
-Prominent usage of the Interface is to communicate with
-Intel Active Management Technology (Intel AMT)
-implemented in firmware running on the Intel ME.
+Prominent usage of the Intel ME Interface is to communicate with Intel(R)
+Active Management Technology (Intel AMT)implemented in firmware running on
+the Intel ME.
 
 Intel AMT provides the ability to manage a host remotely out-of-band (OOB)
-even when the host processor has crashed or is in a sleep state.
+even when the operating system running on the host processor has crashed or
+is in a sleep state.
 
 Some examples of Intel AMT usage are:
    - Monitoring hardware state and platform components
-   - Remote power off/on (useful for green computing or overnight IT maintenance)
+   - Remote power off/on (useful for green computing or overnight IT
+     maintenance)
    - OS updates
    - Storage of useful platform information such as software assets
-   - built-in hardware KVM
-   - selective network isolation of Ethernet and IP protocol flows based on
-     policies set by a remote management console
+   - Built-in hardware KVM
+   - Selective network isolation of Ethernet and IP protocol flows based
+     on policies set by a remote management console
    - IDE device redirection from remote management console
 
 Intel AMT (OOB) communication is based on SOAP (deprecated
-starting with Release 6.0) over HTTP/HTTPS or WS-Management protocol
-over HTTP and HTTPS that are received from a remote
-management console application.
+starting with Release 6.0) over HTTP/S or WS-Management protocol over
+HTTP/S that are received from a remote management console application.
 
 For more information about Intel AMT:
-http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/aboutintelamt.htm
-
+http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
 
-MEI Driver
+Intel MEI Driver
 =======================
 
 The driver exposes a character device called /dev/mei.
 
-An application maintains communication with an ME feature while
-/dev/mei is open. The binding to a specific features is performed
-by calling MEI_CONNECT_CLIENT_IOCTL, which passes the desired UUID.
-The number of instances of an ME feature that can be opened
-at the same time depends on the ME feature, but most of the
+An application maintains communication with an Intel ME feature while
+/dev/mei is open. The binding to a specific features is performed by calling
+MEI_CONNECT_CLIENT_IOCTL, which passes the desired UUID.
+The number of instances of an Intel ME feature that can be opened
+at the same time depends on the Intel ME feature, but most of the
 features allow only a single instance.
 
-
-The Intel AMT Host Interface (AMTHI) feature requires multiple
-simultaneous user applications, therefore the MEI driver handles
+The Intel AMT Host Interface (Intel AMTHI) feature supports multiple
+simultaneous user applications. Therefore, the Intel MEI driver handles
 this internally by maintaining request queues for the applications.
 
-The driver is oblivious to data that are passed between
+The driver is oblivious to data that is passed between firmware feature
+and host application.
 
-Because some of the ME features can change the system
-configuration, the driver by default allows only privileged
+Because some of the Intel ME features can change the system
+configuration, the driver by default allows only a privileged
 user to access it.
 
-A Code snippet for application communicating with AMTHI client:
+A code snippet for an application communicating with
+Intel AMTHI client:
 	struct mei_connect_client_data data;
 	fd = open(MEI_DEVICE);
 
@@ -95,76 +91,106 @@ A Code snippet for application communicating with AMTHI client:
 	[...]
 	close(fd);
 
-ME Applications:
+IOCTL:
+======
+The Intel MEI Driver supports the following IOCTL command:
+	IOCTL_MEI_CONNECT_CLIENT	Connect to firmware Feature (client).
+
+	usage:
+		struct mei_connect_client_data clientData;
+		ioctl(fd, IOCTL_MEI_CONNECT_CLIENT, &clientData);
+
+	inputs:
+		mei_connect_client_data struct contain the following
+		input field:
+
+		in_client_uuid -	UUID of the FW Feature that needs
+					to connect to.
+	outputs:
+		out_client_properties - Client Properties: MTU and Protocol Version.
+
+	error returns:
+		EINVAL	Wrong IOCTL Number
+		ENODEV	Device or Connection is not initialized or ready.
+			(e.g. Wrong UUID)
+		ENOMEM	Unable to allocate memory to client internal data.
+		EFAULT	Fatal Error (e.g. Unable to access user input data)
+		EBUSY	Connection Already Open
+
+	Notes:
+        max_msg_length (MTU) in client properties describes the maximum
+        data that can be sent or received. (e.g. if MTU=2K, can send
+        requests up to bytes 2k and received responses upto 2k bytes).
+
+Intel ME Applications:
 ==============
 
 1) Intel Local Management Service (Intel LMS)
-	Applications running locally on the platform communicate with
-	Intel AMT Release 2.0 and later releases in the same way
-	that network applications do via SOAP over HTTP (deprecated
-	starting with Release 6.0) or with WS-Management over SOAP over
-	HTTP. which means that some Intel AMT feature can be access
-	from a local application using same Network interface as for
-	remote application.
-
-	When a local application sends a message addressed to the local
-	Intel AMT host name, the Local Manageability Service (LMS),
-	which listens for traffic directed to the host name, intercepts
-	the message and routes it to the Intel Management Engine Interface.
+
+	Applications running locally on the platform communicate with Intel AMT Release
+	2.0 and later releases in the same way that network applications do via SOAP
+	over HTTP (deprecated starting with Release 6.0) or with WS-Management over
+	SOAP over HTTP. This means that some Intel AMT features can be accessed from a
+	local application using the same network interface as a remote application
+	communicating with Intel AMT over the network.
+
+	When a local application sends a message addressed to the local Intel AMT host
+	name, the Intel LMS, which listens for traffic directed to the host name,
+	intercepts the message and routes it to the Intel MEI.
 	For more information:
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_
-	Reference_Guide/WordDocuments/localaccess1.htm
-
-	The LMS opens a connection using the MEI driver to the LMS
-	FW feature using a defined UUID and then communicates with the
-	feature using a protocol
-	called Intel(R) AMT Port Forwarding Protocol (APF protocol).
-	The protocol is used to maintain multiple sessions with
-	Intel AMT from a single application.
-	See the protocol specification in
-	the Intel(R) AMT Implementation and Reference Guide
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/HTMLDocuments/MPSDocuments/Intel%20AMT%20Port%20Forwarding%20Protocol%20Reference%20Manual.pdf
-
-  2) Intel AMT Remote configuration using a Local Agent:
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	Under "About Intel AMT" => "Local Access"
+
+	For downloading Intel LMS:
+	http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
+
+	The Intel LMS opens a connection using the Intel MEI driver to the Intel LMS
+	firmware feature using a defined UUID and then communicates with the feature
+	using a protocol called Intel AMT Port Forwarding Protocol(Intel APF protocol).
+	The protocol is used to maintain multiple sessions with Intel AMT from a
+	single application.
+
+	See the protocol specification in the Intel AMT Software Development Kit(SDK)
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	Under "SDK Resources" => "Intel(R) vPro(TM) Gateway(MPS)"
+	=> "Information for Intel(R) vPro(TM) Gateway Developers"
+	=> "Description of the Intel AMT Port Forwarding (APF)Protocol"
+
+  2) Intel AMT Remote configuration using a Local Agent
 	A Local Agent enables IT personnel to configure Intel AMT out-of-the-box
-	without requiring installing additional data to enable setup.
-	The remote configuration process may involve an ISV-developed remote
-	configuration agent that runs on the host.
+	without requiring installing additional data to enable setup. The remote
+	configuration process may involve an ISV-developed remote configuration
+	agent that runs on the host.
 	For more information:
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/remoteconfigurationwithalocalagent.htm
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide
+	Under "Setup and Configuration of Intel AMT" =>
+	"SDK Tools Supporting Setup and Configuration" =>
+	"Using the Local Agent Sample"
+
+	An open source Intel AMT configuration utility,	implementing a local agent
+	that accesses the Intel MEI driver, can be found here:
+	http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/
 
-	How the Local Agent Works (including Command structs):
-	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/howthelocalagentsampleworks.htm
 
 Intel AMT OS Health Watchdog:
 =============================
 The Intel AMT Watchdog is an OS Health (Hang/Crash) watchdog.
 Whenever the OS hangs or crashes, Intel AMT will send an event
-to whoever subscribed to this event. This mechanism means that
-IT knows when a platform crashes even when there is a hard failure
-on the host.
-The AMT Watchdog is composed of two parts:
-	1) FW Feature - that receives the heartbeats
-	   and sends an event when the heartbeats stop.
-	2) MEI driver – connects to the watchdog (WD) feature,
-	   configures the watchdog and sends the heartbeats.
-
-The MEI driver configures the Watchdog to expire by default
-every 120sec unless set by the user using module parameters.
-The Driver then sends heartbeats every 2sec.
+to any subsciber to this event. This mechanism means that
+IT knows when a platform crashes even when there is a hard failureon the host.
 
-If WD feature does not exist (i.e. the connection failed),
-the MEI driver will disable the sending of heartbeats.
+The Intel AMT Watchdog is composed of two parts:
+	1) Firmware feature - receives the heartbeats
+	   and sends an event when the heartbeats stop.
+	2) Intel MEI driver - connects to the watchdog feature, configures the
+	   watchdog and sends the heartbeats.
 
-Module Parameters
-=================
-watchdog_timeout - the user can use this module parameter
-to change the watchdog timeout setting.
+The Intel MEI driver uses the kernel watchdog to configure the Intel AMT
+Watchdog and to send heartbeats to it. The default timeout of the
+watchdog is 120 seconds.
 
-This value sets the Intel AMT watchdog timeout interval in seconds;
-the default value is 120sec.
-in order to disable the watchdog activites set the value to 0.
-Normal values should be between 120 and 65535
+If the Intel AMT Watchdog feature does not exist (i.e. the connection failed),
+the Intel MEI driver will disable the sending of heartbeats.
 
 Supported Chipsets:
 ==================
-- 
1.7.4.1

