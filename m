Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2LCPMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:12:52 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:27383
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab2LCPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:12:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,208,1355094000"; 
   d="scan'208";a="164615138"
Date: Mon, 3 Dec 2012 16:12:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.6 released]
Message-ID: <20121203151247.GG14085@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hardware Locality (hwloc) team is pleased to announce the release
of v1.6:

   http://www.open-mpi.org/projects/hwloc/

v1.6 is a major new release series.  It includes many new features and
changes over the v1.5.x series.  It brings a significant rework of the
core which eases the combining of multiple topology discovery sources,
and future additions of new sources. Some components may also now be
built and loaded as separate plugins, which should make distribution
packagers' life easier.

Aside of this core rework, we have the usual set of small API additions
(one may now export/import its own custom private data to XML), new
command-line tools (hwloc-annotate), new command-line options, some
small discovery improvements.


Version 1.6.0
-------------
* Major changes
  + Reorganize the backend infrastructure to support dynamic selection
    of components and dynamic loading of plugins. For details, see the
    new documentation section Components and plugins.
    - The HWLOC_COMPONENTS variable lets one replace the default discovery
      components.
    - Dynamic loading of plugins may be enabled with --enable-plugins
      (except on AIX and Windows). It will build libxml2 and libpci
      support as separated modules. This helps reducing the dependencies
      of the core hwloc library when distributed as a binary package.
* Backends
  + Add CPUModel detection on Darwin and x86/FreeBSD.
    Thanks to Robin Scher for providing ways to implement this.
  + The x86 backend now adds CPUModel info attributes to socket objects
    created by other backends that do not natively support this attribute.
  + Fix detection on FreeBSD in case of cpuset restriction. Thanks to
    Sebastian Kuzminsky for reporting the problem.
* XML
  + Add hwloc_topology_set_userdata_import/export_callback(),
    hwloc_export_obj_userdata() and _userdata_base64() to let
    applications specify how to save/restore the custom data they placed
    in the userdata private pointer field of hwloc objects.
* Tools
  + Add hwloc-annotate program to add string info attributes to XML
    topologies.
  + Add --pid-cmd to hwloc-ps to append the output of a command to each
    PID line. May be used for showing Open MPI process ranks, see the
    hwloc-ps(1) manpage for details.
  + hwloc-bind now exits with an error if binding fails; the executable
    is not launched unless binding suceeeded or --force was given.
  + Add --quiet to hwloc-calc and hwloc-bind to hide non-fatal error
    messages.
  + Fix command-line pid support in windows tools.
  + All programs accept --verbose as a synonym to -v.
* Misc
  + Fix some DIR descriptor leaks on Linux.
  + Fix I/O device lists when some were filtered out after a XML import.
  + Fix the removal of I/O objects when importing a I/O-enabled XML topology
    without any I/O topology flag.
  + When merging objects with HWLOC_IGNORE_TYPE_KEEP_STRUCTURE or
    lstopo --merge, compare object types before deciding which one of two
    identical object to remove (e.g. keep sockets in favor of caches).
  + Add some GUID- and LID-related info attributes to OpenFabrics
    OS devices.
  + Only add CPUType socket attributes on Solaris/Sparc. Other cases
    don't report reliable information (Solaris/x86), and a replacement
    is available as the Architecture string info in the Machine object.
  + Add missing Backend string info on Solaris in most cases.
  + Document object attributes and string infos in a new Attributes
    section in the documentation.
  + Add a section about Synthetic topologies in the documentation.
